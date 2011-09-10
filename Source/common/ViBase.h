//
//  ViBase.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
#import <OpenGL/OpenGL.h>
#import <OpenGL/gl.h>
#import <OpenGL/glext.h>
#endif

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <QuartzCore/QuartzCore.h>
#endif

#define kViEpsilonFloat 0.0000000001f

#ifdef NDEBUG
#   define ViLog(...) NSLog(_VA_ARGS_)
#else
#   define ViLog(...) (void)0
#endif

namespace vi
{
    /**
     * Common namespace containing common used classes
     **/
    namespace common
    {
    }
    
    /**
     * Namespace which contains graphic related classes
     **/
    namespace graphic
    {
    }
    
    /**
     * Namespace containing input and event related classes
     **/
    namespace input
    {
    }
    
    /**
     * Rendering related namespace
     **/
    namespace scene
    {
    }
}
