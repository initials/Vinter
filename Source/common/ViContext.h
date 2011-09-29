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
            
            EAGLContext *getNativeContext();
            static vi::common::context *getActiveContext();
            
            
        private:            
            bool active;
            pthread_t thread;
            
            GLuint glsl; // Only used on OS X
            EAGLContext *nativeContext;
        };
    }
}
