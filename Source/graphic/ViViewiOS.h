//
//  ViViewiOS.h
//  Vinter2D (iOS)
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#import <UIKit/UIKit.h>
#import "ViViewProtocol.h"
#import "ViBase.h"

/**
 * @brief Render view for iOS.
 **/
@interface ViViewiOS : UIView <ViViewProtocol>
{
@private
    GLint backingWidth;
    GLint backingHeight;
    
    EAGLContext *context;
    
    GLuint viewRenderbuffer; 
	GLuint viewFramebuffer;
}

/**
 * Returns the size of the buffers
 * @sa ViViewProtocol
 **/
- (CGSize)size;
/**
 * Returns the GSlang version
 * @sa ViViewProtocol
 **/
- (uint32_t)glslVersion;

/**
 * Binds the framebuffer
 * @sa ViViewProtocol
 **/
- (void)bind;
/**
 * Unbinds the framebuffer
 * @sa ViViewProtocol
 **/
- (void)unbind;

@end

#endif
