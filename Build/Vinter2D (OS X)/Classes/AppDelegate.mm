//
//  AppDelegate.mm
//  Vinter
//
//  Created by Sidney Just on 8/30/11.
//  Copyright 2011 by Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)handleRenderEvent:(vi::input::event *)event
{
    [window setTitle:[NSString stringWithFormat:@"Vinter2D (%.0f FPS)", 1.0/kernel->timestep]];
    
    vi::common::vector2 pos = camera->frame.origin;
    vi::common::vector2 accel = vi::common::vector2(80 * (vi::input::event::isKeyPressed(2) - vi::input::event::isKeyPressed(0)), 
                                                    80 * (vi::input::event::isKeyPressed(1) - vi::input::event::isKeyPressed(13)));
    
    pos.x += round(accel.x * kernel->timestep);
    pos.y += round(accel.y * kernel->timestep);
    
	camera->frame.origin = pos;
}

- (void)handleMouseEvent:(vi::input::event *)event
{
	static vi::scene::shape *shape = NULL;
    static vi::common::vector2 lastpoint;
    static vi::common::vector2 minpos;
    static vi::common::vector2 maxpos;
    
    if(event->type & vi::input::eventTypeMouseUp)
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
    
    vi::common::vector2 temppoint(event->mousePosition.x+camera->frame.origin.x, event->mousePosition.y+camera->frame.origin.y);
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




- (void)handleEvent:(vi::input::event *)event
{
    if(event->type & vi::input::eventTypeMouse)
    {
        [self handleMouseEvent:event];
    }
    
    if(event->type & vi::input::eventTypeRender)
    {
        [self handleRenderEvent:event];
    }
}


- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    // ------------------------
    // Basic setup that must be done prior to any other Vinter operation.
    // We create a renderer, a camera which draws into our rendering view, a scene and a kernel
    // The kernel object basically glues everything together. We give it the same context as our rendering view as both operate on the same thread
    // ------------------------
    renderer = new vi::graphic::rendererOSX();
    camera = new vi::scene::camera(renderView);
    scene = new vi::scene::scene(camera);
    kernel = new vi::common::kernel(scene, renderer, [renderView context]);
    kernel->startRendering(30); // And then start the rendering
    
    dataPool = new vi::common::dataPool();
    
    dispatch_queue_t workQueue = dispatch_queue_create("com.widerwille.workqueue", NULL);
    dispatch_async(workQueue, ^{
        // ------------------------
        // This dispatch queue creates some data in a background thread, it demonstrates the basic principle of multithreaded Vinter usage
        // Every thread that wants to make a call to the Vinter API needs its own, activated vi::common::context instance. As we also want to share
        // the resources this context creates with the main context, we have to create a shared context by passing another context as the shared context.
        // ------------------------ 
        __block vi::graphic::texture *texture;
        __block vi::graphic::shader *shapeShader;
        
        vi::common::context *context = new vi::common::context([renderView context]); 
        context->activateContext();
        
        // Create texture and shaders
        texture = new vi::graphic::texture("Brick.png");
        shapeShader = new vi::graphic::shader(vi::graphic::defaultShaderShape);
        
        // Its also possible to create sprites or other scene nodes in a background thread
        // However, please note that you can only add them to a scene on the main thread!
        sprite = new vi::scene::sprite(texture);
        sprite->mesh->generateVBO();
        sprite->layer = 2;
        
        delete context; // The context will automatically flush all the changes it made
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Add the sprite to the scene on the main thread.
            scene->addNode(sprite);
            
            dataPool->setAsset(texture, "brickTexture");
            dataPool->setAsset(shapeShader, "shapeShader");
        });
    });
    
    
    
    bridge = vi::common::objCBridge(self, @selector(handleEvent:));
    
    responder = new vi::input::responder();
    responder->callback = std::tr1::bind(&vi::common::objCBridge::parameter1Action<vi::input::event *>, &bridge, std::tr1::placeholders::_1);
    responder->mouseDown = true;
    responder->mouseDragged = true;
    responder->mouseUp = true;
    responder->willDrawScene = true;
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    scene->deleteAllNodes(); // Delete all objects in the scene
    dataPool->removeAllAssets(true); // Delete all loaded assets
    
    delete kernel;
    delete scene;
    delete camera;
    delete responder;
    delete dataPool;
}

@end
