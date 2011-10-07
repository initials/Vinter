//
//  ViViewProtocol.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import <Foundation/Foundation.h>
#import "ViContext.h"

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#import <CoreGraphics/CoreGraphics.h>
#endif

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

