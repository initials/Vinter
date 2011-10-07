//
//  ViContext.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#include <pthread.h>
#import "ViBase.h"

namespace vi
{
    namespace common
    {
        class context
        {
        public:
            context(GLuint glslVersion=120);
            context(vi::common::context *otherContext);
            ~context();
            
            void activateContext();
            void deactivateContext();
            
            void flush();
            
            void setGLSLVersion(GLuint glslVersion);
            GLuint getGLSLVersion();
            
            
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
            EAGLContext *getNativeContext();
#endif
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
            NSOpenGLContext *getNativeContext();
#endif
            
            static vi::common::context *getActiveContext();
            
        private:            
            bool active;
            pthread_t thread;
            
            GLuint glsl; // Only used on OS X
            
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
            EAGLContext *nativeContext;
#endif
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
            NSOpenGLContext *nativeContext;
            NSOpenGLPixelFormat *pixelFormat;
            bool shared;
#endif
        };
    }
}
