//
//  ViewController.m
//  Vinter2D (iOS)
//
//  Created by Sidney Just on 06.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)handleRenderEvent:(vi::input::event *)event
{
    [fpsLabel setText:[NSString stringWithFormat:@"FPS: %.2f", 1/kernel->timestep]];
    
    vi::common::vector2 pos = camera->frame.origin;
    vi::common::vector2 accel = vi::common::vector2(80 * (vi::input::event::isKeyPressed(0) - vi::input::event::isKeyPressed(2)), 
                                                    80 * (vi::input::event::isKeyPressed(1) - vi::input::event::isKeyPressed(13)));
    
    pos.x += round(accel.x * kernel->timestep);
    pos.y += round(accel.y * kernel->timestep);
    
    sprite->rotation += 5 * kernel->timestep;
	camera->frame.origin = pos;
}

- (void)handleTouchEvent:(vi::input::event *)event
{
	static vi::scene::shape *shape = NULL;
    static vi::common::vector2 lastpoint;
    static vi::common::vector2 minpos;
    static vi::common::vector2 maxpos;
   
    vi::common::vector2 mousePosition = vi::common::vector2([[event->touches anyObject] locationInView:event->view]);
    
    if(event->type & vi::input::eventTypeTouchUp)
    {
        if(shape)
        {
            vi::common::vector2 size = vi::common::vector2(maxpos.x-minpos.x, maxpos.y-minpos.y);
            shape->setSize(size);
            shape->setPosition(vi::common::vector2(minpos.x, minpos.y));
            shape->mesh->translate(vi::common::vector2(-minpos.x, minpos.y+size.y));
            shape->setFlags(0);
            shape->generateMesh();
            
            shape->material->drawMode = GL_TRIANGLES;
        }
        
        shape = NULL;
        return;
    }
    
    vi::common::vector2 temppoint(mousePosition.x + camera->frame.origin.x, mousePosition.y + camera->frame.origin.y);
    if(!shape)
    {
        lastpoint = temppoint;
        minpos = lastpoint;
        maxpos = lastpoint;
        
        shape = new vi::scene::shape();
        shape->material->shader = shapeShader;
        
        scene->addNode(shape);
        shape->addVertex(lastpoint.x, -lastpoint.y);
        
        return;
    }
    
    vi::common::vector2 diff = lastpoint - temppoint;
    if(diff.length() > 5.0)
    {
        lastpoint = temppoint;
        shape->addVertex(lastpoint.x, -lastpoint.y);
        
        if(lastpoint.x < minpos.x)
            minpos.x = lastpoint.x;
        
        if(lastpoint.x > maxpos.x)
            maxpos.x = lastpoint.x;
        
        if(lastpoint.y < minpos.y)
            minpos.y = lastpoint.y;
        
        if(lastpoint.y > maxpos.y)
            maxpos.y = lastpoint.y;
    }
}




- (void)handleEvent:(vi::input::event *)event
{
    if(event->type & vi::input::eventTypeTouch)
    {
        [self handleTouchEvent:event];
    }
    
    if(event->type & vi::input::eventTypeRender)
    {
        [self handleRenderEvent:event];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    renderer = new vi::graphic::rendererOSX();
    camera = new vi::scene::camera(renderView);
    scene = new vi::scene::scene();
    kernel = new vi::common::kernel(scene, renderer);
    
    kernel->addCamera(camera);
    kernel->startRendering(30);
    
    texture = new vi::graphic::texture("Brick.png");
    textureShader = new vi::graphic::shader(vi::graphic::defaultShaderTexture);
    shapeShader = new vi::graphic::shader(vi::graphic::defaultShaderShape);
    
    sprite = new vi::scene::sprite(texture);    
    sprite->material->shader = textureShader;
    sprite->mesh->generateVBO();
    
    scene->addNode(sprite);
    
    
    bridge = vi::common::objCBridge(self, @selector(handleEvent:));
    
    responder = new vi::input::responder();
    responder->callback = std::tr1::bind(&vi::common::objCBridge::parameter1Action<vi::input::event *>, &bridge, std::tr1::placeholders::_1);
    responder->touchDown = true;
    responder->touchMoved = true;
    responder->touchUp = true;
    responder->willDrawScene = true;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
