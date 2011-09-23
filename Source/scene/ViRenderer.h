//
//  ViRenderer.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

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
    }
    
    namespace scene
    {
        class scene;
    }
    
    
    namespace graphic
    {
        /**
         * @brief Abstract class that describes the way a renderer has to work.
         *
         * You can create your own renderer by subclassing this class and implementing all described functions.
         **/
        class renderer
        {
        public:
            /**
             * Render the given scene with the given camera. The camera isn't bound when this function is invoked and must unbound before leaving the
             * function.
             **/
            virtual void renderSceneWithCamera(vi::scene::scene *scene, vi::scene::camera *camera, double timestep) = 0;
        };
    }
}
