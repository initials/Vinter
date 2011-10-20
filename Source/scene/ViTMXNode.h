//
//  ViTMXNode.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#include <vector>
#include <string>
#import "ViBase.h"
#import "ViXML.h"
#import "ViTMXLayer.h"
#import "ViSceneNode.h"

namespace vi
{
    namespace scene
    {
        class tmxNode : public sceneNode
        {
        public:
            tmxNode(std::string const& file);
            ~tmxNode();
            
            tmxTileset *tilesetContainingGid(uint32_t gid);
            tmxTileset *tilesetWithName(std::string const& name);
            
            tmxLayer *layerAtIndex(uint32_t index);
            
            uint32_t getLayerCount();
            
        private:
            std::vector<vi::scene::tmxLayer *> _tmxLayer;
            std::vector<vi::scene::tmxTileset *> tmxTilesets;
            
            uint32_t mapWidth;
            uint32_t mapHeight;
            
            uint32_t tileWidth;
            uint32_t tileHeight;
        };
    }
}
