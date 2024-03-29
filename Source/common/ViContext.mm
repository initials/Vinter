//
//  ViContext.mm
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#include <vector>
#import "ViContext.h"

namespace vi
{
    namespace common
    {
        static pthread_mutex_t contextMutex = PTHREAD_MUTEX_INITIALIZER; 
        static std::vector<vi::common::context *> contextList;
        
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
        NSOpenGLPixelFormat *contextCreatePixelFormat(GLuint glslVersion, GLuint *resultGlsl);
        NSOpenGLPixelFormat *contextCreatePixelFormat(GLuint glslVersion, GLuint *resultGlsl)
        {
            GLuint usedGlsl = 120;
            
#if __MAC_OS_X_VERSION_MAX_ALLOWED >= __MAC_10_7
            NSOpenGLPixelFormatAttribute attributes[] =
            {
                NSOpenGLPFAOpenGLProfile, NSOpenGLProfileVersionLegacy,
                NSOpenGLPFADoubleBuffer,
                NSOpenGLPFAColorSize, 24,
                0
            };
            
            if(glslVersion == 150)
            {
                SInt32 OSXversionMajor, OSXversionMinor;
                if(Gestalt(gestaltSystemVersionMajor, &OSXversionMajor) == noErr && Gestalt(gestaltSystemVersionMinor, &OSXversionMinor) == noErr)
                {
                    if(OSXversionMajor == 10 && OSXversionMinor >= 7)
                    {
                        attributes[0] = NSOpenGLPFAOpenGLProfile;
                        attributes[1] = NSOpenGLProfileVersion3_2Core;
                        
                        usedGlsl = 150;
                    }
                }
            }
#else
            NSOpenGLPixelFormatAttribute attributes[] =
            {
                NSOpenGLPFADoubleBuffer,
                NSOpenGLPFAColorSize, 24,
                0
            };
#endif
            
            NSOpenGLPixelFormat *pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attributes];
            assert(pixelFormat != NULL);
            
            if(resultGlsl)
                *resultGlsl = usedGlsl;
            
            return [pixelFormat autorelease];
        }
#endif
        
        
        
        context::context(GLuint glslVersion)
        {
            glsl = glslVersion;
            active = false;
            shared = false;
            
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
            nativeContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
#endif
            
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
            pixelFormat = [vi::common::contextCreatePixelFormat(glslVersion, &glsl) retain];
            nativeContext = [[NSOpenGLContext alloc] initWithFormat:pixelFormat shareContext:nil];
#endif
        }
        
        context::context(vi::common::context *otherContext)
        {
            glsl = otherContext->glsl;
            active = false;
            shared = true;
            sharedContext = otherContext;
            
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
            nativeContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2 sharegroup:[otherContext->nativeContext sharegroup]];
#endif
            
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
            pixelFormat = [otherContext->pixelFormat retain];
            nativeContext = [[NSOpenGLContext alloc] initWithFormat:pixelFormat shareContext:otherContext->nativeContext];
#endif
        }
        
        context::~context()
        {
            flush();
            deactivateContext();
            
            std::map<vi::graphic::defaultShader, vi::graphic::shader *>::iterator iterator;
            for(iterator=defaultShaders.begin(); iterator!=defaultShaders.end(); iterator++)
            {
                vi::graphic::shader *shader = (*iterator).second;
                delete shader;
            }
            
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
            [pixelFormat release];
#endif
            [nativeContext release];
        }
        
        
        
        void context::activateContext()
        {
            if(!active)
            {
                pthread_mutex_lock(&contextMutex);
                pthread_t selfThread = pthread_self();
                
                
                std::vector<vi::common::context *>::iterator iterator;
                for(iterator=contextList.begin(); iterator!=contextList.end(); iterator++)
                {
                    vi::common::context *context = *iterator;                    
                    if(pthread_equal(context->thread, selfThread))
                    {
                        context->active = false;
                        contextList.erase(iterator);
                        
                        break;
                    }
                }
                
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
                [EAGLContext setCurrentContext:nativeContext];
#endif
                
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
                [nativeContext makeCurrentContext];
                
                if(shared)
                {
                    CGLContextObj context = (CGLContextObj)[nativeContext CGLContextObj];
                    CGLEnable(context, kCGLCEMPEngine);
                }
#endif   
                
                contextList.push_back(this);
                thread = selfThread;
                active = true;
                
                pthread_mutex_unlock(&contextMutex);
            }
        }
        
        void context::deactivateContext()
        {
            if(active)
            {
                pthread_mutex_lock(&contextMutex);
                
                std::vector<vi::common::context *>::iterator iterator;
                for(iterator=contextList.begin(); iterator!=contextList.end(); iterator++)
                {
                    vi::common::context *context = *iterator;
                    if(context == this)
                    {
                        contextList.erase(iterator);
                        break;
                    }
                }

#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
                if(shared)
                {
                    CGLContextObj context = (CGLContextObj)[nativeContext CGLContextObj];
                    CGLDisable(context, kCGLCEMPEngine);
                }
#endif  
                
                active = false;
                
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
                [EAGLContext setCurrentContext:nil];
#endif
                
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
                [NSOpenGLContext clearCurrentContext];
#endif   
                
                pthread_mutex_unlock(&contextMutex);
            }
        }
        
        vi::common::context *context::getActiveContext()
        {
            pthread_mutex_lock(&contextMutex);
            pthread_t selfThread = pthread_self();
            
            std::vector<vi::common::context *>::iterator iterator;
            for(iterator=contextList.begin(); iterator!=contextList.end(); iterator++)
            {
                vi::common::context *context = *iterator;
                if(pthread_equal(context->thread, selfThread))
                {
                    pthread_mutex_unlock(&contextMutex);
                    return context;
                }
            }
            
            pthread_mutex_unlock(&contextMutex);
            return NULL;
        }
        
        
        void context::flush()
        {
            if(active)
                glFlush();
        }
        
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
        EAGLContext *context::getNativeContext()
        {
            return nativeContext;
        }
#endif
        
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
        NSOpenGLContext *context::getNativeContext()
        {
            return nativeContext;
        }
#endif
        
        vi::graphic::shader *context::getShader(vi::graphic::defaultShader type)
        {
            if(shared)
            {
                return sharedContext->getShader(type);
            }
            
            std::map<vi::graphic::defaultShader, vi::graphic::shader *>::iterator iterator;
            iterator = defaultShaders.find(type);
            
            if(iterator != defaultShaders.end())
            {
                vi::graphic::shader *shader = (*iterator).second;
                return shader;
            }
            
            vi::graphic::shader *shader = new vi::graphic::shader(type);
            defaultShaders[type] = shader;
            
            return shader;
        }
        
        
        GLuint context::getGLSLVersion()
        {
            return glsl;
        }
    }
}
