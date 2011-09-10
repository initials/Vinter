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

@interface ViViewOSX : NSOpenGLView <ViViewProtocol>
{
@private
    BOOL usesCoreProfile;
}

@property (nonatomic, assign) BOOL allowsCoreProfile;

- (CGSize)size;
- (uint32_t)glslVersion;

- (void)bind;
- (void)unbind;

@end

#endif
