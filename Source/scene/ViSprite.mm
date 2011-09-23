//
//  ViSprite.mm
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViSprite.h"
#import "ViVector3.h"

namespace vi
{
    namespace scene
    {
        sprite::sprite(vi::graphic::texture *texture, bool upsideDown)
        {
            this->setPosition(vi::common::vector2(0.0, 0.0));
            this->setSize(vi::common::vector2(texture->getWidth(), texture->getHeight()));
            
            isUpsideDown = upsideDown;
            ownsMesh = true;
            
            atlasBegin = this->getPosition();
            atlasSize  = this->getSize();
            
            material = new vi::graphic::material(texture);
            material->blending = true;
            material->blendSource = GL_ONE;
            material->blendDestination = GL_ONE_MINUS_SRC_ALPHA;
            
            
            mesh = new vi::common::mesh(4, 6);
            mesh->vertices[0].x = 0.0;
            mesh->vertices[0].y = texture->getHeight();
            mesh->vertices[0].u = 0.0;
            mesh->vertices[0].v = upsideDown ? 1.0 : 0.0;
            
            mesh->vertices[1].x = texture->getWidth();
            mesh->vertices[1].y = texture->getHeight();
            mesh->vertices[1].u = 1.0;
            mesh->vertices[1].v = upsideDown ? 1.0 : 0.0;
            
            
            mesh->vertices[2].x = texture->getWidth();
            mesh->vertices[2].y = 0.0;
            mesh->vertices[2].u = 1.0;
            mesh->vertices[2].v = upsideDown ? 0.0 : 1.0;
            
            mesh->vertices[3].x = 0.0;
            mesh->vertices[3].y = 0.0;
            mesh->vertices[3].u = 0.0;
            mesh->vertices[3].v = upsideDown ? 0.0 : 1.0;
			
			mesh->indices[0] = 0;
			mesh->indices[1] = 3;
			mesh->indices[2] = 1;
			mesh->indices[3] = 2;
			mesh->indices[4] = 1;
			mesh->indices[5] = 3;
        }
        
        sprite::sprite(vi::graphic::texture *texture, vi::common::mesh *sharedMesh)
        {
            this->setPosition(vi::common::vector2(0.0, 0.0));
            this->setSize(vi::common::vector2(texture->getWidth(), texture->getHeight()));
            
            isUpsideDown = false;
            ownsMesh = false;
            
            atlasBegin = this->getPosition();
            atlasSize  = this->getSize();
            
            material = new vi::graphic::material(texture);
            material->blending = true;
            material->blendSource = GL_ONE;
            material->blendDestination = GL_ONE_MINUS_SRC_ALPHA;
            
            mesh = sharedMesh;
        }
        
        sprite::~sprite()
        {
            delete material;
            
            if(ownsMesh)
                delete mesh;
        }
        
        
        void sprite::setTexture(vi::graphic::texture *texture)
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
            
            this->setAtlas(atlasBegin, atlasSize);
        }
        
        void sprite::setAtlas(vi::common::vector2 const& begin, vi::common::vector2 const& size)
        {
            if(!ownsMesh)
                return;
            
            atlasBegin = begin;
            atlasSize  = size;
            
            if(material->textures.size() > 0)
            {                
                vi::graphic::texture *texture = material->textures[0];
                
                CGFloat startU = begin.x / texture->getWidth();
                CGFloat startV = begin.y / texture->getHeight();
                CGFloat endU = (begin.x + size.x) / texture->getWidth();
                CGFloat endV = (begin.y + size.y) / texture->getHeight();

                mesh->vertices[0].x = 0.0;
                mesh->vertices[0].y = size.y;
                mesh->vertices[0].u = startU;
                mesh->vertices[0].v = isUpsideDown ? endV : startV;
                
                mesh->vertices[1].x = size.x;
                mesh->vertices[1].y = size.y;
                mesh->vertices[1].u = endU;
                mesh->vertices[1].v = isUpsideDown ? endV : startV;
                
                
                mesh->vertices[2].x = size.x;
                mesh->vertices[2].y = 0.0;
                mesh->vertices[2].u = endU;
                mesh->vertices[2].v = isUpsideDown ? startV : endV;
                
                mesh->vertices[3].x = 0.0;
                mesh->vertices[3].y = 0.0;
                mesh->vertices[3].u = startU;
                mesh->vertices[3].v = isUpsideDown ? startV : endV;
                
                this->setPosition(this->position);
                this->setSize(size);
            }
        }
    }
}
