//
//  ViViewProtocol.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import <Foundation/Foundation.h>

@protocol ViViewProtocol <NSObject>
@required

- (CGSize)size;
- (uint32_t)glslVersion;

- (void)bind;
- (void)unbind;

@end

void ViViewSetActiveView(id<ViViewProtocol> view);
id<ViViewProtocol> ViViewGetActiveView();
