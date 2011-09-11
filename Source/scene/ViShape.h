//
//  ViSprite.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViSceneNode.h"
#import "ViTexture.h"
#import "ViRenderer.h"

namespace vi
{
    namespace scene
    {
        /**
         * @brief Arbitrary shaped polygon
         *
         * The shape class represents an arbitrary shaped polygon
         **/
        class shape : public sceneNode
        {
        public:
            shape();
            ~shape();
            
            /**
             * Adds a new vertex to the shape
             **/
			void addVertex(float x, float y);
            /**
             * Generate a closed mesh for the shape
             **/
			void generateMesh();
        };
    }
}
