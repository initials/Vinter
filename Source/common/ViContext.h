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
        /**
         * @brief A per thread object managing an OpenGL (ES) context.
         *
         * If you want to perfom tasks in a secondary thread with Vinter, you have to create a context for it. A context can either share
         * its resource (shaders, framebuffer, textures etc) with other contexts or have its completely own stack of resources.
         **/
        class context
        {
        public:
            /**
             * Creates a new context with the specified GSlang version.
             * @param glslVersion The desired GSlang version you want. Only used on OS X. If you pass a version that isn't available, the context will fallback to a known version
             **/
            context(GLuint glslVersion=120);
            /**
             * Creates a new context that shares its resources with the given other context.
             * @remark Use this if you want to create a context that loads assets in a background thread!
             **/
            context(vi::common::context *otherContext);
            /**
             * Destructor. Automatically flushes the context and deactivates it!
             **/
            ~context();
            
            /**
             * Activates the context on the current thread.
             * @remark Only make one context active for one thread and only use the context from the thread that activated it.
             **/
            void activateContext();
            /**
             * Deactivates the context.
             **/
            void deactivateContext();
            
            /**
             * Flushes the contexts resources to make them available to the shared contexts.
             * @remark Call this before accessing newly created resources from another thread, otherwise the data might not be available yet.
             **/
            void flush();
            
            /**
             * Returns the GSlang version the context allows.
             * @remak Only useful on OS X
             **/
            GLuint getGLSLVersion();
            
            
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
            /**
             * Returns the native EAGLContext object this context wraps.
             **/
            EAGLContext *getNativeContext();
#endif
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
            /**
             * Returns the native NSOpenGLContext object this context wraps.
             **/
            NSOpenGLContext *getNativeContext();
#endif
            
            /**
             * Returns the context that is currently active on the calling thread or NULL.
             **/
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
