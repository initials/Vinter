//
//  ViSprite.mm
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViSprite.h"
#import "ViVector3.h"
#import "ViContext.h"

namespace vi
{
    namespace scene
    {
        sprite::sprite(vi::graphic::texture *texture, bool upsideDown)
        {
            if(texture)
                this->setSize(vi::common::vector2(texture->getWidth(), texture->getHeight()));
            
            vi::common::context *context = vi::common::context::getActiveContext();
            assert(context);
            
            isUpsideDown = upsideDown;
            ownsMesh = true;
            
            atlasBegin = vi::common::vector2(0.0f, 0.0f);
            atlasSize  = this->getSize();
            atlasX = atlasY = 0.0f;
            atlasZ = atlasW = 1.0f;
            
            material = new vi::graphic::material(texture, context->getShader(vi::graphic::defaultShaderSprite));
            material->blending = true;
            material->blendSource = GL_ONE;
            material->blendDestination = GL_ONE_MINUS_SRC_ALPHA;
            material->addParameter("atlasTranslation", &atlasX, vi::graphic::materialParameterTypeFloat, 4, 1);
            
            mesh = new vi::common::mesh(4, 6);
            mesh->vertices[0].x = 0.0;
            mesh->vertices[0].y = 1.0;
            mesh->vertices[0].u = 0.0;
            mesh->vertices[0].v = 0.0;
            
            mesh->vertices[1].x = 1.0;
            mesh->vertices[1].y = 1.0;
            mesh->vertices[1].u = 1.0;
            mesh->vertices[1].v = 0.0;
            
            mesh->vertices[2].x = 1.0;
            mesh->vertices[2].y = 0.0;
            mesh->vertices[2].u = 1.0;
            mesh->vertices[2].v = 1.0;
            
            mesh->vertices[3].x = 0.0;
            mesh->vertices[3].y = 0.0;
            mesh->vertices[3].u = 0.0;
            mesh->vertices[3].v = 1.0;
            
            mesh->indices[0] = 0;
            mesh->indices[1] = 3;
            mesh->indices[2] = 1;
            mesh->indices[3] = 2;
            mesh->indices[4] = 1;
            mesh->indices[5] = 3;
        }
        
        sprite::sprite(vi::graphic::texture *texture, vi::common::mesh *sharedMesh)
        {
            if(texture)
                this->setSize(vi::common::vector2(texture->getWidth(), texture->getHeight()));
            
            vi::common::context *context = vi::common::context::getActiveContext();
            assert(context);
            
            isUpsideDown = false;
            ownsMesh = false;
            
            atlasBegin = vi::common::vector2(0.0f, 0.0f);
            atlasSize  = this->getSize();
            atlasX = atlasY = 0.0f;
            atlasZ = atlasW = 1.0f;
            
            material = new vi::graphic::material(texture, context->getShader(vi::graphic::defaultShaderSprite));
            material->blending = true;
            material->blendSource = GL_ONE;
            material->blendDestination = GL_ONE_MINUS_SRC_ALPHA;
            material->addParameter("atlasTranslation", &atlasX, vi::graphic::materialParameterTypeFloat, 4, 1);
            
            mesh = sharedMesh;
        }
        
        
        sprite::~sprite()
        {
            if(material)
                delete material;
            
            if(ownsMesh && mesh)
                delete mesh;
        }
        
        
        void sprite::visit(double timestep)
        {            
            sceneNode::visit(timestep);
            matrix.scale(vi::common::vector3(size.x, size.y, 1.0f));
        }
        
        void sprite::setTexture(vi::graphic::texture *texture)
        {
            if(material)
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
        }
        
        void sprite::setAtlas(vi::common::vector2 const& begin, vi::common::vector2 const& size)
        {
            atlasBegin = begin;
            atlasSize  = size;
            
            if(material && material->textures.size() > 0)
            {                
                vi::graphic::texture *texture = material->textures[0];
                
                atlasX = begin.x / texture->getWidth();
                atlasY = begin.y / texture->getHeight();
                atlasZ = size.x / texture->getWidth();
                atlasW = size.y / texture->getHeight();
            }
            
            this->setSize(size);
        }
    }
}
