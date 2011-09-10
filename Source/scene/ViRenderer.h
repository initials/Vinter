//
//  ViRenderer.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import <Foundation/Foundation.h>
#import "ViBase.h"
#import "ViTexture.h"
#import "ViMaterial.h"
#import "ViShader.h"
#import "ViCamera.h"

namespace vi
{
    namespace common
    {
        class camera;
        class mesh;
    }
    
    namespace scene
    {
        class scene;
        class sceneNode;
    }
    
    
    namespace graphic
    {
        class renderer
        {
        public:
            virtual void renderSceneWithCamera(vi::scene::scene *scene, vi::scene::camera *camera) = 0;
            
            virtual void renderNode(vi::scene::sceneNode *node) = 0;
            virtual void setMaterial(vi::graphic::material *material) = 0;
        };
    }
}
