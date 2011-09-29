//
//  ViBase.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
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

#define ViVersionMajor 0
#define ViVersionMinor 3
#define ViVersionPatch 0
#define ViVersionCurrent (((ViVersionMajor) << 16) | ((ViVersionMinor) << 8) | (ViVersionPatch))

#define kViEpsilonFloat 0.0000000001f

#ifndef NDEBUG
#   define ViLog(...) NSLog(__VA_ARGS__)
#else
#   define ViLog(...) (void)0
#endif

