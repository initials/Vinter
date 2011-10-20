//
//  AppDelegate.mm
//  TMXMaps
//
//  Created by Sidney Just on 20.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)handleEvent:(vi::input::event *)event
{
    [window setTitle:[NSString stringWithFormat:@"TMXMaps (%.0f FPS)", 1.0/kernel->timestep]];
    
    vi::common::vector2 pos = camera->frame.origin;
    vi::common::vector2 accel = vi::common::vector2(80 * (vi::input::event::isKeyPressed(2) - vi::input::event::isKeyPressed(0)), 
                                                    80 * (vi::input::event::isKeyPressed(1) - vi::input::event::isKeyPressed(13)));
    
    pos.x += round(accel.x * kernel->timestep);
    pos.y += round(accel.y * kernel->timestep);
    
	camera->frame.origin = pos;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    renderer = new vi::graphic::rendererOSX();
    camera = new vi::scene::camera(renderView);
    scene = new vi::scene::scene(camera);
    kernel = new vi::common::kernel(scene, renderer, [renderView context]);
    kernel->startRendering(60);
    
    tmxScene = new vi::scene::tmxNode("TMX Map.tmx");
    scene->addNode(tmxScene);
    
    bridge = vi::common::objCBridge(self, @selector(handleEvent:));
    
    responder = new vi::input::responder();
    responder->callback = std::tr1::bind(&vi::common::objCBridge::parameter1Action<vi::input::event *>, &bridge, std::tr1::placeholders::_1);
    responder->willDrawScene = true;
}

@end
