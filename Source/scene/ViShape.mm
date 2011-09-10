//
//  ViSprite.mm
//  Vinter
//
//  Copyright 2011 by Nils Daumann Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViShape.h"
#import "ViVector3.h"
#import "ViTriangulate.h"

namespace vi
{
    namespace scene
    {
        shape::shape()
        {
            this->setPosition(vi::common::vector2(0.0, 0.0));
            this->setSize(vi::common::vector2(1.0, 1.0));
            
            flags |= vi::scene::sceneNodeFlagNoclip;
            
            material = new vi::graphic::material();
            material->blending = true;
            material->blendSource = GL_ONE;
            material->blendDestination = GL_ONE_MINUS_SRC_ALPHA;
            material->drawMode = GL_LINES;
            
            mesh = new vi::common::mesh(0, 0);
        }
        
        shape::~shape()
        {
            delete material;
            delete mesh;
        }
		
        
		void shape::addVertex(float x, float y)
		{
			mesh->addVertex(x, y);
		}
		
		void shape::generateMesh()
		{
			std::vector<vi::common::vector2> outline;
			for(int i=0; i<mesh->vertexCount; i++)
			{
				outline.push_back(vi::common::vector2(mesh->vertices[i].x, mesh->vertices[i].y));
			}
			
			std::vector<vi::common::vector2> result;
			vi::common::triangulate::process(outline, result);
			
			mesh->vertexCount = (uint32_t)result.size();
            mesh->indexCount = mesh->vertexCount;
            
			mesh->vertices = (vi::common::vertex *)realloc(mesh->vertices, mesh->vertexCount * sizeof(vi::common::vertex));
			mesh->indices = (unsigned short *)realloc(mesh->indices, mesh->indexCount * sizeof(unsigned short));
			
			for(int i = 0; i < mesh->vertexCount; i++)
			{
				mesh->vertices[i].x = result[i].x;
				mesh->vertices[i].y = result[i].y;
				mesh->indices[i] = i;
			}
			
//			mesh->triangulate();
		}
    }
}
