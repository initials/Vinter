//
//  ViViewiOS.m
//  Vinter2D (iOS)
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#import "ViViewiOS.h"
#import "ViEvent.h"

@implementation ViViewiOS

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (uint32_t)glslVersion
{
    return 0;
}

- (CGSize)size
{
    return CGSizeMake(backingWidth, backingHeight);
}

#pragma mark -
#pragma mark Render events

- (void)bind
{
    [EAGLContext setCurrentContext:context];
    glBindFramebuffer(GL_FRAMEBUFFER, viewFramebuffer);
    
    ViViewSetActiveView(self);
}

- (void)unbind
{
    glBindRenderbuffer(GL_RENDERBUFFER, viewRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER];
}


- (void)drawRect:(CGRect)dirtyRect
{
    [self bind];
    [self unbind];
}


#pragma mark -
#pragma mark Buffer

- (void)generateBuffer
{
    glGenFramebuffers(1, &viewFramebuffer);
	glGenRenderbuffers(1, &viewRenderbuffer);
	glBindFramebuffer(GL_FRAMEBUFFER, viewFramebuffer);
	glBindRenderbuffer(GL_RENDERBUFFER, viewRenderbuffer);
	glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, viewRenderbuffer);
	
	glBindRenderbuffer(GL_RENDERBUFFER, viewRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
	glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
	
	if(glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
	{
        ViLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
    }
}

- (void)destroyFramebuffer 
{
    glDeleteFramebuffers(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffers(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
}

- (void)layoutSubviews
{
    [EAGLContext setCurrentContext:context];
    
    [self destroyFramebuffer];
    [self generateBuffer];
    
    glViewport(0, 0, backingWidth, backingHeight);
}

#pragma mark -

- (BOOL)setupView 
{
	CAEAGLLayer *layer = (CAEAGLLayer *)[self layer];
	NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, 
                                                                            kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
    
    
    [layer setOpaque:YES];
    [layer setDrawableProperties:properties];

	context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
	return (context && [EAGLContext setCurrentContext:context]);
}


- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super initWithCoder:decoder]))
    {
        if(![self setupView])
        {
            [self release];
            return nil;
        }
        
        [self generateBuffer];
        [self setMultipleTouchEnabled:YES];
        
        ViViewSetActiveView(self);
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame]))
    {
        if(![self setupView])
        {
            [self release];
            return nil;
        }
        
        [self generateBuffer];
        [self setMultipleTouchEnabled:YES];
        
        ViViewSetActiveView(self);
    }
    
    return self;
}

- (void)dealloc
{
    [self destroyFramebuffer];
    [context release];
    [super dealloc];
}

#pragma mark -
#pragma mark Input

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    vi::input::event(event, vi::input::eventTypeTouch | vi::input::eventTypeTouchDown, self);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    vi::input::event(event, vi::input::eventTypeTouch | vi::input::eventTypeTouchMoved, self);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    vi::input::event(event, vi::input::eventTypeTouch | vi::input::eventTypeTouchUp, self);
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    vi::input::event(event, vi::input::eventTypeTouch | vi::input::eventTypeTouchCancelled, self);
}

@end
#endif
