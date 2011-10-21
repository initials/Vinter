//
//  ViTMXLayer.mm
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViTMXLayer.h"
#import "ViTMXNode.h"
#import "ViDataPool.h"
#import "ViTexture.h"
#import "ViTexturePVR.h"

namespace vi
{
    namespace scene
    {
        tmxTileset::tmxTileset(vi::common::xmlElement *element)
        {
            name = element->valueOfAttributeNamed("name");
            std::string _firstgid = element->valueOfAttributeNamed("firstgid");
            std::string _tileWidth = element->valueOfAttributeNamed("tilewidth");
            std::string _tileHeight = element->valueOfAttributeNamed("tileheight");
            
            firstGid    = (uint32_t)atol(_firstgid.c_str());
            tileWidth   = (uint32_t)atol(_tileWidth.c_str());
            tileHeight  = (uint32_t)atol(_tileHeight.c_str());
            
            vi::common::xmlElement *image = element->childNamed("image");
            std::string textureName = image->valueOfAttributeNamed("source");
            bool isPVR = (textureName.find("pvr") != std::string::npos);
            
            texture = (isPVR == false) ? new vi::graphic::texture(textureName) : new vi::graphic::texturePVR(textureName);
            lastGid = (texture->getWidth() / tileWidth) * (texture->getHeight() / tileHeight);
        }
        
        tmxTileset::~tmxTileset()
        {
            delete texture;
        }
        
        
        
        
        tmxLayer::tmxLayer(vi::common::xmlElement *element, tmxNode *tnode)
        {
            tileset = NULL;            
            node = tnode;
            
            std::string _width  = element->valueOfAttributeNamed("width");
            std::string _height = element->valueOfAttributeNamed("height");
            
            name = element->valueOfAttributeNamed("name");
            width  = (uint32_t)atol(_width.c_str());
            height = (uint32_t)atol(_height.c_str());
            
            vi::common::xmlElement *dataElement = element->childNamed("data");
            std::string encoding = dataElement->valueOfAttributeNamed("encoding");
            std::string compression = dataElement->valueOfAttributeNamed("compression");
            
            if(encoding.compare("base64") != 0)
            {
                ViLog(@"Unknon encoding %s. Can't create TMX layer %s!", encoding.c_str(), name.c_str());
                return;
            }
            
            std::vector<uint8_t> data = vi::common::dataPool::base64decode(dataElement->text());
            if(compression.compare("zlib") == 0 || compression.compare("gzip") == 0)
            {
                data = vi::common::dataPool::inflateMemory(data);
            }
            else if(compression.length() > 0)
            {
                ViLog(@"Unknon compression %s. Can't create TMX layer %s!", compression.c_str(), name.c_str());
                return;
            }

            
            
            uint32_t gid, i=0;
            do {
                memcpy(&gid, &data[i], sizeof(uint32_t));
                i += sizeof(uint32_t);
            } while(gid == 0);
            
            tileset = node->tilesetContainingGid(gid);
            spriteBatch = new vi::scene::spriteBatch(tileset->texture);
            
            vi::common::vector2 textureSize = vi::common::vector2(tileset->texture->getWidth(), tileset->texture->getHeight());
            vi::common::vector2 tileSize = vi::common::vector2(tileset->tileWidth, tileset->tileHeight);
            
            
            i = 0;
            for(uint32_t y=0; y<height; y++)
            {
                for(uint32_t x=0; x<width; x++)
                {
                    memcpy(&gid, &data[i], sizeof(uint32_t));
                    gid = CFSwapInt32LittleToHost(gid);
                    
                    if(gid > 0) 
                    {
                        gid -= tileset->firstGid;
                        vi::common::vector2 atlas = vi::common::vector2(gid % (uint32_t)(tileset->texture->getWidth() / tileset->tileWidth),
                                                                        gid / (uint32_t)(tileset->texture->getWidth() / tileset->tileWidth));
                        

                        vi::scene::sprite *sprite = spriteBatch->addSprite();
                        sprite->setPosition(vi::common::vector2(x * tileset->tileWidth, y * tileset->tileHeight));
                        sprite->setAtlas(atlas * tileSize, tileSize);
                    }
                    
                    i += sizeof(uint32_t);
                }
            }
            
            addChild(spriteBatch);
            setSize(vi::common::vector2(width * tileset->tileWidth, height * tileset->tileHeight));
        }
        
        tmxLayer::~tmxLayer()
        {
            delete spriteBatch;
        }
        
        std::string tmxLayer::getName()
        {
            return name;
        }
    }
}
