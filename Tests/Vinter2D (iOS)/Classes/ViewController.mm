//
//  ViewController.mm
//  Vinter2D (iOS)
//
//  Created by Sidney Just on 06.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)handleRenderEvent:(vi::input::event *)event
{
    NSString *mode = editMode ? @"Edit mode!" : @"Normal mode!";
    [fpsLabel setText:[NSString stringWithFormat:@"FPS: %.2f %@\nRotate!", 1/kernel->timestep, mode]];
}

- (void)handleTouchEvent:(vi::input::event *)event
{
    if(editMode)
    {
        static vi::scene::shape *shape = NULL;
        static vi::common::vector2 lastpoint;
        static vi::common::vector2 minpos;
        static vi::common::vector2 maxpos;
        
        vi::common::vector2 touchPos = [[event->touches anyObject] locationInView:event->view];
        
        if(event->type & vi::input::eventTypeTouchUp || event->type == vi::input::eventTypeTouchCancelled)
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
        
        vi::common::vector2 temppoint(touchPos.x+camera->frame.origin.x, touchPos.y+camera->frame.origin.y);
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
    else
    {
        if(event->type & vi::input::eventTypeTouchMoved)
        {
            UITouch *touch = [event->touches anyObject];
            
            vi::common::vector2 posThen = vi::common::vector2([touch previousLocationInView:event->view]);
            vi::common::vector2 posNow = vi::common::vector2([touch locationInView:event->view]);
            
            vi::common::vector2 diff = posNow - posThen;
            camera->frame.origin -= diff;
        }
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
    
    vi::graphic::texture::setDefaultFormat(vi::graphic::textureFormatRGBA5551);
    
    renderer = new vi::graphic::rendererOSX();
    camera = new vi::scene::camera(renderView);
    scene  = new vi::scene::scene();
    kernel = new vi::common::kernel(scene, renderer, [renderView context]);
    
    kernel->scaleFactor = [[UIScreen mainScreen] scale];
    kernel->addCamera(camera);
    kernel->startRendering(30);
    
    
    dispatch_queue_t workQueue = dispatch_queue_create("com.widerwille.workqueue", NULL);
    dispatch_async(workQueue, ^{
        vi::common::context *context = new vi::common::context([renderView context]); // Every thread needs its own context, however, since we want to share data between our contexts, we have to create a new one that shares with the old context
        context->activateContext(); // And the context needs to be activated, otherwise bad things will happen!
        
        // Load the data in the background
        texture = new vi::graphic::texturePVR("BrickC.pvr");
        textureShader = new vi::graphic::shader(vi::graphic::defaultShaderTexture);
        shapeShader = new vi::graphic::shader(vi::graphic::defaultShaderShape);
        
        // We can also create a sprite in the background
        sprite = new vi::scene::sprite(texture);    
        sprite->material->shader = textureShader;
        sprite->mesh->generateVBO();
        sprite->layer = 2;
        
        context->flush(); // Don't forget to call this, otherwise your data might not get synchronized
        
        dispatch_async(dispatch_get_main_queue(), ^{
            scene->addNode(sprite); // The scene isn't thread safe so we have to add the sprite to the scene in the main thread.
        });
        
        delete context;
    });
    
    
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
    editMode = UIInterfaceOrientationIsLandscape(interfaceOrientation);
    return YES;
}

@end
