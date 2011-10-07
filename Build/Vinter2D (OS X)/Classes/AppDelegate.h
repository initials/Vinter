//
//  AppDelegate.h
//  Vinter
//
//  Created by Sidney Just on 8/30/11.
//  Copyright 2011 by Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
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
    
    vi::graphic::texture *texture;
    vi::graphic::shader *textureShader;
    vi::graphic::shader *shapeShader;
    
    vi::scene::sprite *sprite;
    
    vi::input::responder *responder;
    vi::common::objCBridge bridge;
}
@end
