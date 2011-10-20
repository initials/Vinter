//
//  ViTMXLayer.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#include <vector>
#import "ViBase.h"
#import "ViXML.h"
#import "ViSceneNode.h"
#import "ViSpriteBatch.h"

namespace vi
{
    namespace scene
    {
        class tmxLayer;
        class tmxNode;
        
        class tmxTileset
        {
            friend class tmxLayer;
            friend class tmxNode;
        public:
            tmxTileset(vi::common::xmlElement *element);
            ~tmxTileset();
            
        private:            
            std::string name;
            
            uint32_t firstGid;
            uint32_t lastGid;
            uint32_t tileWidth;
            uint32_t tileHeight;
            
            vi::graphic::texture *texture;
        };
        
        
        class tmxLayer : public sceneNode
        {
        public:
            tmxLayer(vi::common::xmlElement *element, tmxNode *node);
            virtual ~tmxLayer();
            
            std::string getName();
            
        private:
            tmxTileset *tileset;
            tmxNode *node;
            
            std::string name;
            
            uint32_t width;
            uint32_t height;
            
            vi::scene::spriteBatch *spriteBatch;
            std::vector<vi::scene::sprite *> tiles;
        };
    }
    
}
