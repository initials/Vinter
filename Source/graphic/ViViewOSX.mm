//
//  ViViewOSX.m
//  Vinter
//
//  Copyright 2011 by Nils Daumann Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
#import "ViBase.h"
#import "ViViewOSX.h"
#import "ViEvent.h"
#import "ViKernel.h"

@implementation ViViewOSX
@synthesize allowsCoreProfile;

- (uint32_t)glslVersion
{
    return usesCoreProfile ? 150 : 120;
}

- (CGSize)size
{
    return [self bounds].size;
}

#pragma mark -
#pragma mark Render events

- (void)bind
{
    [[self openGLContext] makeCurrentContext];
    ViViewSetActiveView(self);
}

- (void)unbind
{
    [[self openGLContext] flushBuffer];
}



#pragma mark -
#pragma mark Constructor / Destructor

- (NSOpenGLPixelFormat *)createPixelFormat
{
#if __MAC_OS_X_VERSION_MAX_ALLOWED >= __MAC_10_7
    NSOpenGLPixelFormatAttribute attributes[] =
    {
        NSOpenGLPFAOpenGLProfile, NSOpenGLProfileVersionLegacy,
        NSOpenGLPFADoubleBuffer,
        NSOpenGLPFAColorSize, 24,
        0
    };
    

    if(allowsCoreProfile)
    {
        SInt32 OSXversionMajor, OSXversionMinor;
        if(Gestalt(gestaltSystemVersionMajor, &OSXversionMajor) == noErr && Gestalt(gestaltSystemVersionMinor, &OSXversionMinor) == noErr)
        {
            if(OSXversionMajor == 10 && OSXversionMinor >= 7)
            {
                attributes[0] = NSOpenGLPFAOpenGLProfile;
                attributes[1] = NSOpenGLProfileVersion3_2Core;
                
                usesCoreProfile = YES;
            }
        }
    }
#else
    NSOpenGLPixelFormatAttribute attributes[] =
    {
        NSOpenGLPFADoubleBuffer,
        NSOpenGLPFAColorSize, 24,
        0
    };
#endif
    
    NSOpenGLPixelFormat *pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attributes];
    NSAssert(pixelFormat != NULL, @"No OpenGL pixel format!");
    
    return [pixelFormat autorelease];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder]))
    {
        [self setPixelFormat:[self createPixelFormat]];
        [[self openGLContext] makeCurrentContext];
        
        ViViewSetActiveView(self);
    }
    
    return self;
}

- (id)initWithFrame:(NSRect)frame pixelFormat:(NSOpenGLPixelFormat *)pixelFormat
{	
	if(!pixelFormat)
		pixelFormat = [self createPixelFormat];
	
    if((self = [super initWithFrame:frame pixelFormat:pixelFormat]))
    {
        [[self openGLContext] makeCurrentContext];
        
        ViViewSetActiveView(self);
    }
    
	return self;
}

- (id)initWithFrame:(NSRect)frame
{
	return [self initWithFrame:frame pixelFormat:nil];
}

#pragma mark -
#pragma mark Input

- (BOOL)acceptsFirstResponder
{
    return YES;
}
- (void)keyDown:(NSEvent *)theEvent
{
    vi::input::event(theEvent, vi::input::eventTypeKeyboard | vi::input::eventTypeKeyDown);
}

- (void)keyUp:(NSEvent *)theEvent
{
    vi::input::event(theEvent, vi::input::eventTypeKeyboard | vi::input::eventTypeKeyUp);
}


- (void)mouseDown:(NSEvent *)theEvent
{
    vi::input::event(theEvent, vi::input::eventTypeMouse | vi::input::eventTypeMouseDown);
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    vi::input::event(theEvent, vi::input::eventTypeMouse | vi::input::eventTypeMouseDragged);
}

- (void)mouseUp:(NSEvent *)theEvent
{
    vi::input::event(theEvent, vi::input::eventTypeMouse | vi::input::eventTypeMouseUp);
}

@end
#endif
