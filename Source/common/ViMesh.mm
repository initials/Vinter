//
//  ViMesh.mm
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViMesh.h"

namespace vi
{
    namespace common
    {  
        mesh::mesh(uint32_t tcount, uint32_t indcount)
        {
            vbo = vbo0 = vbo1 = -1;
            ivbo = ivbo0 = ivbo1 = -1;
            
            vboToggled = false;
            dynamic = false;
            
            vertexCount = tcount;
			indexCount = indcount;
            
            vertices = (vertex *)malloc(vertexCount * sizeof(vertex));
			indices = (unsigned short *)malloc(indexCount * sizeof(unsigned short));
        }
        
        mesh::~mesh()
        {
            if(vertices)
                free(vertices);
            
            if(indices)
                free(indices);
            
            if(vbo0 != -1)
                glDeleteBuffers(1, &vbo0);
            if(ivbo0 != -1)
                glDeleteBuffers(1, &ivbo0);
            
            if(vbo1 != -1)
                glDeleteBuffers(1, &vbo1);
            if(ivbo1 != -1)
                glDeleteBuffers(1, &ivbo1);
        }
        
        
        
        void mesh::translate(vi::common::vector2 const&  offset)
        {
            for(uint32_t i=0; i<vertexCount; i++)
            {
                vertices[i].x += offset.x;
                vertices[i].y += offset.y;
            }
        }
		
		void mesh::addVertex(float x, float y)
		{
			vertexCount += 1;
			vertices = (vertex *)realloc(vertices, vertexCount * sizeof(vertex));
			vertices[vertexCount-1].x = x;
			vertices[vertexCount-1].y = y;
			
            indexCount += (indexCount == 0) ? 1 : 2;
			indices = (unsigned short *)realloc(indices, indexCount * sizeof(unsigned short));
            
			if(indexCount > 1)
			{
				indices[indexCount-2] = vertexCount-1;
				indices[indexCount-1] = vertexCount-1;
			}
            else
			{
				indices[indexCount-1] = vertexCount-1;
			}
		}
		
		void mesh::triangulate()
		{
            if(vertexCount < 3)
                return;
            
			indexCount = 3 * (vertexCount-2);
			indices = (unsigned short *)realloc(indices, indexCount * sizeof(unsigned short));
			for(int i=0; i<indexCount; i+=3)
			{
				indices[i] = 0;
				indices[i+1] = i / 3+1;
				indices[i+2] = i / 3+2;
			}
		}
        
        
        void mesh::generateVBO(bool dyn)
        {
            dynamic = dyn;
            
            if(vbo0 != -1)
                glDeleteBuffers(1, &vbo0);
            if(ivbo0 != -1)
                glDeleteBuffers(1, &ivbo0);
            
            if(vbo1 != -1)
                glDeleteBuffers(1, &vbo1);
            if(ivbo1 != -1)
                glDeleteBuffers(1, &ivbo1);
            
            vbo = -1;
            ivbo = -1;
            
            vbo0 = -1;
            ivbo0 = -1;
            
            vbo1 = -1;
            ivbo1 = -1;
            
            vboToggled = false;
            
            if(!dynamic)
            {
                glGenBuffers(1, &vbo0);
                glBindBuffer(GL_ARRAY_BUFFER, vbo0);
                glBufferData(GL_ARRAY_BUFFER, vertexCount * sizeof(vertex), vertices, GL_STATIC_DRAW);
                glBindBuffer(GL_ARRAY_BUFFER, 0);
                
                glGenBuffers(1, &ivbo0);
                glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ivbo0);
                glBufferData(GL_ELEMENT_ARRAY_BUFFER, indexCount * sizeof(unsigned short), indices, GL_STATIC_DRAW);
                glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
            }
            else
            {
                glGenBuffers(1, &vbo0);
                glBindBuffer(GL_ARRAY_BUFFER, vbo0);
                glBufferData(GL_ARRAY_BUFFER, vertexCount * sizeof(vertex), vertices, GL_DYNAMIC_DRAW);
                glBindBuffer(GL_ARRAY_BUFFER, 0);
                
                glGenBuffers(1, &ivbo0);
                glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ivbo0);
                glBufferData(GL_ELEMENT_ARRAY_BUFFER, indexCount * sizeof(unsigned short), indices, GL_DYNAMIC_DRAW);
                glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
                
                glGenBuffers(1, &vbo1);
                glBindBuffer(GL_ARRAY_BUFFER, vbo1);
                glBufferData(GL_ARRAY_BUFFER, vertexCount * sizeof(vertex), vertices, GL_DYNAMIC_DRAW);
                glBindBuffer(GL_ARRAY_BUFFER, 0);
                
                glGenBuffers(1, &ivbo1);
                glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ivbo1);
                glBufferData(GL_ELEMENT_ARRAY_BUFFER, indexCount * sizeof(unsigned short), indices, GL_DYNAMIC_DRAW);
                glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
            }
            
            vbo = vbo0;
            ivbo = ivbo0;
        }
        
        void mesh::updateVBO()
        {
            if(!dynamic)
                return;
            
            vboToggled = !vboToggled;
            if(vboToggled)
            {
                vbo = vbo1;
                ivbo = ivbo1;
                
                glBindBuffer(GL_ARRAY_BUFFER, vbo0);
                glBufferSubData(GL_ARRAY_BUFFER, 0, vertexCount * sizeof(vertex), vertices);
                glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
                
                glBindBuffer(GL_ARRAY_BUFFER, ivbo0);
                glBufferSubData(GL_ARRAY_BUFFER, 0, indexCount * sizeof(unsigned short), indices);
                glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
            }
            else
            {
                vbo = vbo0;
                ivbo = ivbo0;
                
                glBindBuffer(GL_ARRAY_BUFFER, vbo1);
                glBufferSubData(GL_ARRAY_BUFFER, 0, vertexCount * sizeof(vertex), vertices);
                glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
                
                glBindBuffer(GL_ARRAY_BUFFER, ivbo1);
                glBufferSubData(GL_ARRAY_BUFFER, 0, indexCount * sizeof(unsigned short), indices);
                glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
            }
        }
    }
}
