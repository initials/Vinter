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
        class spriteBatch : public sceneNode
        {
        public:
            spriteBatch(vi::graphic::texture *texture=NULL);
            ~spriteBatch();
            
            vi::scene::sprite *addSprite();
            void removeSprite(vi::scene::sprite *sprite);
            
            void setTexture(vi::graphic::texture *texture);
            void generateMesh(bool generateVBO=true);
            
            virtual void visit(double timestep);
            
        private:
            void calculateSize();
            
            bool dirty;
            std::vector<vi::scene::sprite *>sprites;
        };
    }
}
