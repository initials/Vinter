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
            
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
            nativeContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
#endif
            
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
            pixelFormat = [vi::common::contextCreatePixelFormat(glslVersion, &glsl) retain];
            nativeContext = [[NSOpenGLContext alloc] initWithFormat:pixelFormat shareContext:nil];
            shared = false;
#endif
        }
        
        context::context(vi::common::context *otherContext)
        {
            glsl = otherContext->glsl;
            active = false;
            
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
            nativeContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2 sharegroup:[otherContext->nativeContext sharegroup]];
#endif
            
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
            pixelFormat = [otherContext->pixelFormat retain];
            nativeContext = [[NSOpenGLContext alloc] initWithFormat:pixelFormat shareContext:otherContext->nativeContext];
            shared = true; // Flag it so that we later switch kCGLCEMPEngine on once the context became active
#endif
        }
        
        context::~context()
        {
            deactivateContext();
            
            [nativeContext release];
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
            [pixelFormat release];
#endif
        }
        
        
        
        void context::activateContext()
        {
            if(!active)
            {
                pthread_mutex_lock(&contextMutex);
                
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
                [EAGLContext setCurrentContext:nativeContext];
#endif
                
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
                [nativeContext makeCurrentContext];
                
                if(shared)
                {
                    CGLContextObj context = (CGLContextObj)[nativeContext CGLContextObj];
                    CGLError error = CGLEnable(context, kCGLCEMPEngine);
                    if(error != kCGLNoError)
                    {
                        throw "Enabling multithreaded OpenGL context failed!";
                    }
                }
#endif   
                
                contextList.push_back(this);
                thread = pthread_self();
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
            pthread_t thread = pthread_self();
            
            std::vector<vi::common::context *>::iterator iterator;
            for(iterator=contextList.begin(); iterator!=contextList.end(); iterator++)
            {
                vi::common::context *context = *iterator;
                if(pthread_equal(context->thread, thread))
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
        
        
        void context::setGLSLVersion(GLuint glslVersion)
        {
            glsl = glslVersion;
        }
        
        GLuint context::getGLSLVersion()
        {
            return glsl;
        }
    }
}
