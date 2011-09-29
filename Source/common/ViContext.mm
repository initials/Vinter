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
        
        context::context(GLuint glslVersion)
        {
            glsl = glslVersion;
            active = false;
            
            nativeContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        }
        
        context::context(vi::common::context *otherContext)
        {
            glsl = otherContext->glsl;
            active = false;
            
            nativeContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2 sharegroup:[otherContext->nativeContext sharegroup]];
        }
        
        context::~context()
        {
            deactivateContext();
            [nativeContext release];
        }
        
        
        
        void context::activateContext()
        {
            if(!active)
            {
                pthread_mutex_lock(&contextMutex);
                
                [EAGLContext setCurrentContext:nativeContext];
                
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
                [EAGLContext setCurrentContext:nil];
                
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
        
        EAGLContext *context::getNativeContext()
        {
            return nativeContext;
        }
        
        
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
