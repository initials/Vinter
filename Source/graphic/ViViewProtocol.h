//
//  ViViewProtocol.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import <Foundation/Foundation.h>
#import "ViContext.h"

/**
 * Protocol that must be implemented by rendering views to allow cameras to render into them
 **/
@protocol ViViewProtocol <NSObject>
@required
/**
 * Must return the size of the buffers
 **/
- (CGSize)size;
/**
 * Must bind the frame buffer.
 **/
- (void)bind;
/**
 * Must initiate the buffer swapping.
 **/
- (void)unbind;

- (vi::common::context *)context;

@end

/**
 * Should be invoked if the view becomes active (eg. if it got bound, or after creation)
 * @remark Shaders depend on the active view to automatically set #version
 **/
void ViViewSetActiveView(id<ViViewProtocol> view);
/**
 * Returns the currently active view
 **/
id<ViViewProtocol> ViViewGetActiveView();
