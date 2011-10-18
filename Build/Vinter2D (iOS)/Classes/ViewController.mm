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
            shape->material->shader = (vi::graphic::shader *)dataPool->assetForName("shapeShader");
            
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
    
    // ------------------------
    // Basic setup that must be done prior to any other Vinter operation.
    // We create a renderer, a camera which draws into our rendering view, a scene and a kernel
    // The kernel object basically glues everything together. We give it the same context as our rendering view as both operate on the same thread
    // ------------------------
    renderer = new vi::graphic::rendererOSX();
    camera = new vi::scene::camera(renderView);
    scene  = new vi::scene::scene();
    kernel = new vi::common::kernel(scene, renderer, [renderView context]);
    
    kernel->scaleFactor = [renderView contentScaleFactor]; // Set the kernels scale factor as soon as possible as other things may depend on it!
    kernel->addCamera(camera);
    kernel->startRendering(30);
    
    dataPool = new vi::common::dataPool();
    
    
    // Set the default texture format, upon texture loading, vinter will try to convert the texture into this formart
    vi::graphic::texture::setDefaultFormat(vi::graphic::textureFormatRGBA5551);
    
    dispatch_queue_t workQueue = dispatch_queue_create("com.widerwille.workqueue", NULL);
    dispatch_async(workQueue, ^{
        // ------------------------
        // This dispatch queue creates some data in a background thread, it demonstrates the basic principle of multithreaded Vinter usage
        // Every thread that wants to make a call to the Vinter API needs its own, activated vi::common::context instance. As we also want to share
        // the resources this context creates with the main context, we have to create a shared context by passing another context as the shared context.
        // -------------------------
        __block vi::graphic::texturePVR *texture;
        __block vi::graphic::shader *shapeShader;
        
        vi::common::context *context = new vi::common::context([renderView context]); 
        context->activateContext();
        
        // Create texture and shaders
        texture = new vi::graphic::texturePVR("BrickC.pvr");
        shapeShader = new vi::graphic::shader(vi::graphic::defaultShaderShape);
        
        // Its also possible to create sprites or other scene nodes in a background thread
        // However, please note that you can only add them to a scene on the main thread!
        sprite = new vi::scene::sprite(texture);
        sprite->mesh->generateVBO();
        sprite->layer = 2;
        
        delete context;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Add the sprite to the scene on the main thread.
            scene->addNode(sprite);
            
            // Also add the assets to the data pool on the main thread
            dataPool->setAsset(texture, "brickTexture");
            dataPool->setAsset(shapeShader, "shapeShader");
        });
    });
    
    
    bridge = vi::common::objCBridge(self, @selector(handleEvent:));
    
    responder = new vi::input::responder();
    responder->callback = std::tr1::bind(&vi::common::objCBridge::parameter1Action<vi::input::event *>, &bridge, std::tr1::placeholders::_1);
    responder->touchDown = true;
    responder->touchMoved = true;
    responder->touchUp = true;
    responder->willDrawScene = true;
}


- (void)viewDidUnload
{
    // Free up everything we own
    scene->deleteAllNodes(); // Delete all objects in the scene
    dataPool->removeAllAssets(true); // Delete all loaded assets
    
    delete kernel;
    delete scene;
    delete camera;
    delete responder;
    delete dataPool;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    editMode = UIInterfaceOrientationIsLandscape(interfaceOrientation);
    return YES;
}

@end
