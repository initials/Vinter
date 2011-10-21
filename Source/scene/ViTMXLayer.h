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
        
        /**
         * @cond
         **/
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
        /**
         * @endcond
         **/
        
        
        /**
         * @brief Representing a layer in a TMX structure
         *
         * A tmxLayer represents a single layer of a tmxNode, wrapping a sprite batch containing all the tiles of the layer.
         **/
        class tmxLayer : public sceneNode
        {
        public:
            /**
             * Constructor.
             * @remark You normally don't call this constructor correctly.
             **/
            tmxLayer(vi::common::xmlElement *element, tmxNode *node);
            /**
             * Destructor.
             **/
            virtual ~tmxLayer();
            
            /**
             * Returns the name of the layer.
             **/
            std::string getName();
            
        private:
            tmxTileset *tileset;
            tmxNode *node;
            
            std::string name;
            
            uint32_t width;
            uint32_t height;
            
            vi::scene::spriteBatch *spriteBatch;
        };
    }
    
}
