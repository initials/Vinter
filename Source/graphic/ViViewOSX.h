//
//  ViViewOSX.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
#import <Cocoa/Cocoa.h>
#import "ViViewProtocol.h"

/**
 * @brief Mac OS X render view
 **/
@interface ViViewOSX : NSOpenGLView <ViViewProtocol>
{
@private
    vi::common::context *context;
}

/**
 * YES if the view should use the OpenGL 3.2 Core Profile if available, otherwise NO
 * @remark Every context that shared with the context of the view must be recreated!
 **/
@property (nonatomic, assign) BOOL allowsCoreProfile;

/**
 * Returns the size of the buffers
 * @sa ViViewProtocol
 **/
- (CGSize)size;
/**
 * Returns the GSlang version
 * @sa ViViewProtocol
 **/
- (vi::common::context *)context;
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
