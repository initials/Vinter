//
//  ViewController.h
//  Vinter2D (iOS)
//
//  Created by Sidney Just on 06.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vinter.h"

@interface ViewController : UIViewController
{
    IBOutlet ViViewiOS *renderView;
    IBOutlet UILabel *fpsLabel;
    
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
