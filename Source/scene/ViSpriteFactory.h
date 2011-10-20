//
//  ViSpriteFactory.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViBase.h"
#import "ViVector2.h"
#import "ViSprite.h"
#import "ViMesh.h"

namespace vi
{
    namespace scene
    {
        /**
         * @brief Class that creates sprites that share a single mesh
         *
         * The sprite factory creates and maintains one simple mesh that is used by all sprites that it creates.
         * The mesh is backed by an VBO.
         *
         * @remark A sprite factory has to live at least as long as the sprites it creates!
         **/
        class spriteFactory
        {
        public:
            /**
             * Constructor
             **/
            spriteFactory();
            /**
             * Destructor, automatically destroy the mesh with it, so only destroy the spriteFactory once you are done using the mesh it generated.
             **/
            ~spriteFactory();
            
            
            /**
             * Creates a new sprite that uses the shared mesh.
             **/
            vi::scene::sprite *createSprite(vi::graphic::texture *texture=NULL);
            /**
             * Returns the shared mesh.
             **/
            vi::common::mesh *getMesh();
            
        private:
            vi::common::mesh *mesh;        
        };
    }
}
