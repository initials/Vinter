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
        typedef enum
        {
            tmxNodeOrientationUnknown,
            tmxNodeOrientationOrthogonal,
            tmxNodeOrientationIsometric
        } tmxNodeOrientation;
        
        /**
         * @brief Wrapper for a TMX map file.
         *
         * A tmxNode can be created from an TMX file created by tiled ( http://www.mapeditor.org ), it automatically parses the TMX file
         * and creates the needed layers. You can simply add the node to your scene hierarchy.
         **/
        class tmxNode : public sceneNode
        {
        public:
            /**
             * Constructor.
             * @param file The name of the TMX file
             **/
            tmxNode(std::string const& file);
            /**
             * Destructor.
             **/
            ~tmxNode();
            
            /**
             * @cond
             **/
            tmxTileset *tilesetContainingGid(uint32_t gid);
            tmxTileset *tilesetWithName(std::string const& name);
            /**
             * @endcond
             **/
            
            /**
             * Returns the TMX layer at the given index or NULL if the index is out of bounds.
             **/
            tmxLayer *layerAtIndex(uint32_t index);
            /**
             * Returns the number of layers inside the node.
             **/
            uint32_t getLayerCount();
            tmxNodeOrientation getOrientation();
            
            uint32_t getTileWidth();
            uint32_t getTileHeight();
            
        private:
            std::vector<vi::scene::tmxLayer *> _tmxLayer;
            std::vector<vi::scene::tmxTileset *> tmxTilesets;
            
            tmxNodeOrientation orientation;
            
            uint32_t mapWidth;
            uint32_t mapHeight;
            
            uint32_t tileWidth;
            uint32_t tileHeight;
        };
    }
}
