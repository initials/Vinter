//
//  AppDelegate.h
//  TMXMaps
//
//  Created by Sidney Just on 20.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Vinter.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
@private
    IBOutlet NSWindow *window;
    IBOutlet ViViewOSX *renderView;
    
    vi::common::kernel *kernel;
    vi::scene::camera *camera;
    vi::scene::scene *scene;
    vi::graphic::rendererOSX *renderer;
    
    vi::scene::tmxNode *tmxScene;
    
    vi::input::responder *responder;
    vi::common::objCBridge bridge;
}

@end
