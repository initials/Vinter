//
//  ViSpriteBatch.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#include <vector>
#import "ViBase.h"
#import "ViTexture.h"
#import "ViSceneNode.h"
#import "ViSprite.h"

namespace vi
{
    namespace scene
    {
        /**
         * @brief Contains a large amount of sprites for efficient rendering.
         *
         * A sprite batch should be used when you render a large amount of sprites sharing the same texture, the sprite batch
         * will automatically create one large mesh containing all sprites. Instead of adding each sprite to a scene, you just add the sprite batch
         * which will then automatically render the mesh.
         **/
        class spriteBatch : public sceneNode
        {
        public:
            /**
             * Constructor for a new sprite batch with the given texture.
             **/
            spriteBatch(vi::graphic::texture *texture=NULL);
            /**
             * Destructor.
             **/
            ~spriteBatch();
            
            /**
             * Adds a new sprite to the sprite batch and returns it.
             * @retval Pointer to the newly created sprite, you can then alter the sprite as if it was attached to the scene.
             * @sa generateMesh()
             **/
            vi::scene::sprite *addSprite();
            /**
             * Removes the given sprite.
             * @sa generateMesh()
             **/
            void removeSprite(vi::scene::sprite *sprite);
            
            /**
             * Sets a new texture.
             * @sa generateMesh()
             **/
            void setTexture(vi::graphic::texture *texture);
            
            /**
             * Regenerates the whole mesh and marks the batch as clean.
             * @remark This operation can be slow, so the sprite batch will only automatically call it once its about to appear on the screen again and its data has changed.
             * @remark If you update a sprite manually and miss the mesh generation, you have to call this function manually!
             **/
            void generateMesh(bool generateVBO=true);
            
            /**
             * If the batch is marked as dirty, this is, if you called addSprite(), setTexture() or removeSprite() in the previous frame, the
             * batch will automatically call generateMesh(true);
             **/
            virtual void visit(double timestep);
            
        private:
            void calculateSize();
            
            bool dirty;
            std::vector<vi::scene::sprite *>sprites;
        };
    }
}
