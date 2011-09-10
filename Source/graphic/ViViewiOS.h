//
//  ViViewiOS.h
//  Vinter2D (iOS)
//
//  Copyright 2011 by Nils Daumann Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#import <UIKit/UIKit.h>
#import "ViViewProtocol.h"
#import "ViBase.h"

@interface ViViewiOS : UIView <ViViewProtocol>
{
@private
    GLint backingWidth;
    GLint backingHeight;
    
    EAGLContext *context;
    
    GLuint viewRenderbuffer; 
	GLuint viewFramebuffer;
}

- (CGSize)size;
- (uint32_t)glslVersion;

- (void)bind;
- (void)unbind;


@end

#endif
