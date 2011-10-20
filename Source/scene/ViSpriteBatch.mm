//
//  ViSpriteBatch.mm
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViSpriteBatch.h"
#import "ViContext.h"
#import "ViMaterial.h"

namespace vi
{
    namespace scene
    {
        spriteBatch::spriteBatch(vi::graphic::texture *texture)
        {
            vi::common::context *context = vi::common::context::getActiveContext();
            assert(context);
            
            material = new vi::graphic::material(texture, context->getShader(vi::graphic::defaultShaderTexture));
            material->blending = true;
            material->blendSource = GL_ONE;
            material->blendDestination = GL_ONE_MINUS_SRC_ALPHA;
            
            dirty = false;
        }
        
        spriteBatch::~spriteBatch()
        {
            std::vector<vi::scene::sprite *>::iterator iterator;
            for(iterator=sprites.begin(); iterator!=sprites.end(); iterator++)
            {
                vi::scene::sprite *sprite = *iterator;
                delete sprite;
            }
            
            if(mesh)
                delete mesh;
            
            delete material;
        }
        
        void spriteBatch::visit(double timestep)
        {
            if(dirty)
                generateMesh();
            
            vi::scene::sceneNode::visit(timestep);
        }
        
        
        vi::scene::sprite *spriteBatch::addSprite()
        {
            dirty = true;
            
            vi::graphic::texture *texture = (material->textures.size() > 0) ? material->textures[0] : NULL;
            vi::scene::sprite *sprite = new vi::scene::sprite(texture);
            
            delete sprite->material;
            delete sprite->mesh;
            
            sprite->material = NULL;
            sprite->mesh = NULL;
            
            sprites.push_back(sprite);
            return sprite;
        }
        
        void spriteBatch::removeSprite(vi::scene::sprite *sprite)
        {
            std::vector<vi::scene::sprite *>::iterator iterator;
            for(iterator=sprites.begin(); iterator!=sprites.end(); iterator++)
            {
                vi::scene::sprite *tsprite = *iterator;
                if(sprite == tsprite)
                {
                    delete tsprite;
                    sprites.erase(iterator);
                    
                    break;
                }
            }
            
            dirty = true;
        }
        
        void spriteBatch::setTexture(vi::graphic::texture *texture)
        {   
            if(material->textures.size() == 0)
            {
                material->textures.push_back(texture);
                material->texlocations.push_back(1);
            }
            else
            {
                material->textures[0] = texture;
            }
            
            dirty = true;
        }
        
        
        
        void spriteBatch::calculateSize()
        {
            GLfloat maxWidth = 0, maxHeight = 0;
            
            std::vector<vi::scene::sprite *>::iterator iterator;
            for(iterator=sprites.begin(); iterator!=sprites.end(); iterator++)
            {
                vi::scene::sprite *sprite = *iterator;
                vi::common::vector2 tposition = sprite->getPosition();
                vi::common::vector2 tsize = sprite->getSize();
                
                if(maxWidth < tposition.x + tsize.x)
                    maxWidth = tposition.x + tsize.x;
                
                if(maxHeight < tposition.y + tsize.y)
                    maxHeight = tposition.y + tsize.y;
            }
            
            setSize(vi::common::vector2(maxWidth, maxHeight));
        }
        
        void spriteBatch::generateMesh(bool generateVBO)
        {
            calculateSize();
            
            if(mesh)
                delete mesh;
            
            mesh = new vi::common::mesh((uint32_t)sprites.size() * 4, (uint32_t)sprites.size() * 6);
            
            
            std::vector<vi::scene::sprite *>::iterator iterator;
            uint32_t vindex = 0;
            uint32_t iindex = 0;
            
            vi::common::vector2 textureSize;
            vi::graphic::texture *texture = NULL;
            
            if(material->textures.size() > 0)
            {                
                texture = material->textures[0];
                textureSize = vi::common::vector2(texture->getWidth(), texture->getHeight());
            }
            
            for(iterator=sprites.begin(); iterator!=sprites.end(); iterator++)
            {
                vi::scene::sprite *sprite = *iterator;
                vi::common::vector2 tposition = sprite->getPosition();
                vi::common::vector2 tsize = sprite->getSize();
                
                vi::common::vector2 atlasXY;
                vi::common::vector2 atlasWH;
                
                tposition.y = -tposition.y;
                tposition.y += size.y - tsize.y;
                
                

                if(texture)
                {
                    atlasXY = sprite->atlasBegin / textureSize;
                    atlasWH = (sprite->atlasBegin + sprite->atlasSize) / textureSize;
                }
                
                mesh->vertices[vindex + 0].x = tposition.x;
                mesh->vertices[vindex + 0].y = tposition.y + tsize.y;
                mesh->vertices[vindex + 0].u = atlasXY.x;
                mesh->vertices[vindex + 0].v = atlasXY.y;
                
                mesh->vertices[vindex + 1].x = tposition.x + tsize.x;
                mesh->vertices[vindex + 1].y = tposition.y + tsize.y;
                mesh->vertices[vindex + 1].u = atlasWH.x;
                mesh->vertices[vindex + 1].v = atlasXY.y;
                
                mesh->vertices[vindex + 2].x = tposition.x + tsize.x;
                mesh->vertices[vindex + 2].y = tposition.y;
                mesh->vertices[vindex + 2].u = atlasWH.x;
                mesh->vertices[vindex + 2].v = atlasWH.y;
                
                mesh->vertices[vindex + 3].x = tposition.x;
                mesh->vertices[vindex + 3].y = tposition.y;
                mesh->vertices[vindex + 3].u = atlasXY.x;
                mesh->vertices[vindex + 3].v = atlasWH.y;
                                
                
                mesh->indices[iindex + 0] = vindex + 0;
                mesh->indices[iindex + 1] = vindex + 3;
                mesh->indices[iindex + 2] = vindex + 1;
                mesh->indices[iindex + 3] = vindex + 2;
                mesh->indices[iindex + 4] = vindex + 1;
                mesh->indices[iindex + 5] = vindex + 3;
                
                vindex += 4;
                iindex += 6;
            }
            
            if(generateVBO)
                mesh->generateVBO();
            
            dirty = false;
        }
    }
}
