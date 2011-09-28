//
//  ViSpriteFactory.mm
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViSpriteFactory.h"

namespace vi
{
    namespace scene
    {
        spriteFactory::spriteFactory(vi::common::vector2 const& size)
        {
            mesh = new vi::common::mesh(4, 6);
            mesh->vertices[0].x = 0.0;
            mesh->vertices[0].y = size.y;
            mesh->vertices[0].u = 0.0;
            mesh->vertices[0].v = 0.0;
            
            mesh->vertices[1].x = size.x;
            mesh->vertices[1].y = size.y;
            mesh->vertices[1].u = 1.0;
            mesh->vertices[1].v = 0.0;
            
            
            mesh->vertices[2].x = size.x;
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
            
            mesh->generateVBO();
        }
        
        spriteFactory::~spriteFactory()
        {
            delete mesh;
        }
        
        
        void spriteFactory::setSize(vi::common::vector2 const& size)
        {
            mesh->vertices[0].y = size.y;
            mesh->vertices[1].x = size.x;
            mesh->vertices[1].y = size.y;
            mesh->vertices[2].x = size.x;
            
            mesh->generateVBO();
        }
        
        
        vi::scene::sprite *spriteFactory::createSprite(vi::graphic::texture *texture)
        {
            vi::scene::sprite *sprite = new vi::scene::sprite(texture, mesh);
            return sprite;
        }
        
        vi::common::mesh *spriteFactory::getMesh()
        {
            return mesh;
        }
    }
}