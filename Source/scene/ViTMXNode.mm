//
//  ViTMXNode.mm
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViTMXNode.h"
#import "ViTexture.h"
#import "ViTexturePVR.h"

#define kViTmxNodeSupportedVersion "1.0"
#define kViTmxNodeSupportedOrientation "orthogonal"

namespace vi
{
    namespace scene
    {             
        tmxNode::tmxNode(std::string const& file)
        {
            vi::common::xmlParser *parser = new vi::common::xmlParser(file);
            vi::common::xmlElement *map = parser->getRootElement();
            if(map)
            {
                std::string _version = map->valueOfAttributeNamed("version");
                if(_version.compare(kViTmxNodeSupportedVersion) != 0)
                {
                    ViLog(@"Tried to create tmxNode with unknown TMX version!");
                    return;
                }
                
                // Get the map meta data
                std::string _mapOrientation = map->valueOfAttributeNamed("orientation");
                std::string _mapWidth  = map->valueOfAttributeNamed("width");
                std::string _mapHeight = map->valueOfAttributeNamed("height");
                std::string _tileWidth  = map->valueOfAttributeNamed("tilewidth");
                std::string _tileHeight = map->valueOfAttributeNamed("tileheight");
                
                orientation = tmxNodeOrientationUnknown;
                
                if(_mapOrientation.compare("orthogonal") == 0)
                    orientation = tmxNodeOrientationOrthogonal;
                
                if(_mapOrientation.compare("isometric") == 0)
                    orientation = tmxNodeOrientationIsometric;
                
                    
                if(orientation == tmxNodeOrientationUnknown)
                {
                    ViLog(@"Tried to create tmxNode with an unsupported orientation!");
                    return;
                }
                
                mapWidth  = (uint32_t)atol(_mapWidth.c_str());
                mapHeight = (uint32_t)atol(_mapHeight.c_str());
                tileWidth  = (uint32_t)atol(_tileWidth.c_str());
                tileHeight = (uint32_t)atol(_tileHeight.c_str());
                
                setSize(vi::common::vector2(mapWidth * tileWidth, mapHeight * tileHeight));
                
                // Parse all tilesets
                vi::common::xmlElement *tilesetElement = map->childNamed("tileset");
                while(tilesetElement)
                {
                    tmxTileset *tileset = new tmxTileset(tilesetElement);
                    tmxTilesets.push_back(tileset);
                    
                    tilesetElement = tilesetElement->siblingNamed("tileset");
                }
                
                // And all layers
                vi::common::xmlElement *layerElement = map->childNamed("layer");
                while(layerElement)
                {
                    vi::scene::tmxLayer *layer = new vi::scene::tmxLayer(layerElement, this);
                    _tmxLayer.push_back(layer);
                    
                    addChild(layer);
                    layerElement = layerElement->siblingNamed("layer");
                }
            }
            
            delete parser;
        }
        
        tmxNode::~tmxNode()
        {
            do {
                std::vector<vi::scene::tmxTileset *>::iterator iterator;
                for(iterator=tmxTilesets.begin(); iterator!=tmxTilesets.end(); iterator++)
                {
                    tmxTileset *tileset = *iterator;
                    delete tileset;
                }
            } while(0);
            
            do {
                std::vector<vi::scene::tmxLayer *>::iterator iterator;
                for(iterator=_tmxLayer.begin(); iterator!=_tmxLayer.end(); iterator++)
                {
                    tmxLayer *layer = *iterator;
                    delete layer;
                }
            } while (0);
        }
        
        
        tmxTileset *tmxNode::tilesetContainingGid(uint32_t gid)
        {
            std::vector<vi::scene::tmxTileset *>::iterator iterator;
            for(iterator=tmxTilesets.begin(); iterator!=tmxTilesets.end(); iterator++)
            {
                tmxTileset *tileset = *iterator;
                
                if(gid >= tileset->firstGid && gid <= tileset->lastGid)
                    return tileset;
            }
            
            return NULL;
        }
        
        tmxTileset *tmxNode::tilesetWithName(std::string const& name)
        {
            std::vector<vi::scene::tmxTileset *>::iterator iterator;
            for(iterator=tmxTilesets.begin(); iterator!=tmxTilesets.end(); iterator++)
            {
                tmxTileset *tileset = *iterator;
                
                if(tileset->name.compare(name) == 0)
                    return tileset;
            }
            
            return NULL;
        }
        
        tmxLayer *tmxNode::layerAtIndex(uint32_t index)
        {
            if(index >= _tmxLayer.size())
                return NULL;
            
            return _tmxLayer[index];
        }
        
        uint32_t tmxNode::getLayerCount()
        {
            return (uint32_t)_tmxLayer.size();
        }
        
        tmxNodeOrientation tmxNode::getOrientation()
        {
            return orientation;
        }
        
        uint32_t tmxNode::getTileWidth()
        {
            return tileWidth;
        }
        
        uint32_t tmxNode::getTileHeight()
        {
            return tileHeight;
        }
    }
}
