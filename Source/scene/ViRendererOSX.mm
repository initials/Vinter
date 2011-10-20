//
//  ViRendererOSX.mm
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViRendererOSX.h"
#import "ViQuadtree.h"
#import "ViSceneNode.h"
#import "ViVector3.h"
#import "ViKernel.h"

namespace vi
{
    namespace graphic
    {
        rendererOSX::rendererOSX()
        {
            lastVBO = 0;
            lastMesh = NULL;
            
            currentCamera = NULL;
            currentMaterial = NULL;
            
            uniformIvFuncs[0] = glUniform1iv;
            uniformIvFuncs[1] = glUniform2iv;
            uniformIvFuncs[2] = glUniform3iv;
            uniformIvFuncs[3] = glUniform4iv;
            
            uniformFvFuncs[0] = glUniform1fv;
            uniformFvFuncs[1] = glUniform2fv;
            uniformFvFuncs[2] = glUniform3fv;
            uniformFvFuncs[3] = glUniform4fv;
            
            uniformMatrixFvFuncs[0] = glUniformMatrix2fv;
            uniformMatrixFvFuncs[1] = glUniformMatrix3fv;
            uniformMatrixFvFuncs[2] = glUniformMatrix4fv;
        }
        
       
        
        void rendererOSX::renderSceneWithCamera(vi::scene::scene *scene, vi::scene::camera *camera, double timestep)
        {
            camera->bind();
            currentCamera = camera;
            
            std::vector<vi::scene::sceneNode *> *nodes = scene->nodesInRect(camera->frame);
            this->renderNodeList(nodes, timestep);
            
            camera->unbind();
        }
        
        void rendererOSX::renderNodeList(std::vector<vi::scene::sceneNode *> *nodes, double timestep)
        {
            std::vector<vi::scene::sceneNode *>::iterator iterator;
            
            for(iterator=nodes->begin(); iterator!=nodes->end(); iterator++)
            {
                vi::scene::sceneNode *node = *iterator;
                
                if(node->noPass == currentCamera)
                    continue;
                
                node->visit(timestep);
                
                this->setMaterial(node->material);
                this->renderNode(node);
                
                if(node->hasChilds())
                {
                    vi::common::vector2 nodePos = node->getPosition();
                    
                    translation += nodePos;
                    this->renderNodeList(node->getChilds(), timestep);
                    translation -= nodePos;
                }
            }
        }
        
        void rendererOSX::renderNode(vi::scene::sceneNode *node)
        {
            if(!node->mesh)
                return; 
            
  
            vi::common::matrix4x4 nodeMatrix = node->matrix;
            if(translation.length() >= kViEpsilonFloat)
            {
                nodeMatrix.translate(vi::common::vector3(translation.x, -translation.y, translation.z));
            }
            
            if(currentMaterial->shader->matProj != -1)
				glUniformMatrix4fv(currentMaterial->shader->matProj, 1, GL_FALSE, currentCamera->projectionMatrix.matrix);
            
            if(currentMaterial->shader->matView != -1)
                glUniformMatrix4fv(currentMaterial->shader->matView, 1, GL_FALSE, currentCamera->viewMatrix.matrix);
			
            if(currentMaterial->shader->matModel != -1)
                glUniformMatrix4fv(currentMaterial->shader->matModel, 1, GL_FALSE, nodeMatrix.matrix);
            
            if(currentMaterial->shader->matProjViewModel != -1)
            {
                vi::common::matrix4x4 matProjViewModel = currentCamera->projectionMatrix * currentCamera->viewMatrix * nodeMatrix;
                glUniformMatrix4fv(currentMaterial->shader->matProjViewModel, 1, GL_FALSE, matProjViewModel.matrix);
            }
            
            
            std::vector<vi::graphic::materialParameter>::iterator iterator;
            for(iterator=currentMaterial->parameter.begin(); iterator!=currentMaterial->parameter.end(); iterator++)
            {
                vi::graphic::materialParameter parameter = *iterator;
                
                if(parameter.location == -1)
                    continue;
            
                
                switch(parameter.type)
                {
                    case vi::graphic::materialParameterTypeInt:
                    {
                        uniformIvFuncs[parameter.count - 1](parameter.location, parameter.size, (const GLint *)parameter.data);
                    }
                        break;
                        
                    case vi::graphic::materialParameterTypeFloat:
                    {
                        uniformFvFuncs[parameter.count - 1](parameter.location, parameter.size, (const GLfloat *)parameter.data);
                    }
                        break;
                        
                    case vi::graphic::materialParameterTypeMatrix:
                    {
                        uniformMatrixFvFuncs[parameter.count - 2](parameter.location, parameter.size, GL_FALSE, (const GLfloat *)parameter.data);
                    }
                        break;
                        
                    default:
                        break;
                }
            }
            
            if(node->mesh->vbo == -1)
            {
                glBindBuffer(GL_ARRAY_BUFFER, 0);
                lastVBO = -1;
                
                if(lastMesh != node->mesh)
                {
                    lastMesh = node->mesh;
                    
                    if(currentMaterial->shader->position != -1)
                        glDisableVertexAttribArray(currentMaterial->shader->position);
                    
                    if(currentMaterial->shader->texcoord0 != -1)
                        glDisableVertexAttribArray(currentMaterial->shader->texcoord0);
                    
                    
                    
                    if(currentMaterial->shader->position != -1)
                    {
                        glEnableVertexAttribArray(currentMaterial->shader->position);
                        glVertexAttribPointer(currentMaterial->shader->position, 2, GL_FLOAT, 0, sizeof(vi::common::vertex), &node->mesh->vertices[0].x);
                    }
                    
                    if(currentMaterial->shader->texcoord0 != -1)
                    {
                        glEnableVertexAttribArray(currentMaterial->shader->texcoord0);
                        glVertexAttribPointer(currentMaterial->shader->texcoord0, 2, GL_FLOAT, 0, sizeof(vi::common::vertex), &node->mesh->vertices[0].u);
                    }
                }
            }
            else
            {
                if(lastVBO != node->mesh->vbo)
                {
                    glBindBuffer(GL_ARRAY_BUFFER, node->mesh->vbo);
                    lastVBO = node->mesh->vbo;
                    lastMesh = NULL;
                    
                    if(currentMaterial->shader->position != -1)
                        glDisableVertexAttribArray(currentMaterial->shader->position);
                    
                    if(currentMaterial->shader->texcoord0 != -1)
                        glDisableVertexAttribArray(currentMaterial->shader->texcoord0);
                    
                    
                    if(currentMaterial->shader->position != -1)
                    {
                        glEnableVertexAttribArray(currentMaterial->shader->position);
                        glVertexAttribPointer(currentMaterial->shader->position, 2, GL_FLOAT, 0, sizeof(vi::common::vertex), (const void *)0);
                    }
                    
                    if(currentMaterial->shader->texcoord0 != -1)
                    {
                        glEnableVertexAttribArray(currentMaterial->shader->texcoord0);
                        glVertexAttribPointer(currentMaterial->shader->texcoord0, 2, GL_FLOAT, 0, sizeof(vi::common::vertex), (const void *)8);
                    }
                }
            }
            

            if(node->mesh->ivbo == -1)
			{
                lastIVBO = -1;
                
				glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
				glDrawElements(currentMaterial->drawMode, node->mesh->indexCount, GL_UNSIGNED_SHORT, node->mesh->indices);
			}
            else
            {
                if(lastIVBO != node->mesh->ivbo)
                {
                    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, node->mesh->ivbo);
                    lastIVBO = node->mesh->ivbo;
                }
                
				glDrawElements(currentMaterial->drawMode, node->mesh->indexCount, GL_UNSIGNED_SHORT, 0);
			}
        }
        
        
        void rendererOSX::setMaterial(vi::graphic::material *material)
        {
            if(!material)
                return;
            
            if(!material->shader)
            {
                static bool complaintAboutShader = false;
                if(!complaintAboutShader)
                {
                    ViLog(@"Tried to enable a material in a shader based renderer but the material had no shader! This error will be reported once");
                    complaintAboutShader = true;
                }
                
                return;
            }
            
            if(currentMaterial != material)
            {
                glUseProgram(material->shader->program);
                
                if(!currentMaterial || (currentMaterial->textures != material->textures || currentMaterial->texlocations != material->texlocations))
                {
                    if(material->textures.size() > 0)
                    {
                        for(int i=0; i<material->texlocations.size(); i++)
                        {
                            if(material->texlocations[i] == -1)
                                break;
                            
                            glActiveTexture(GL_TEXTURE0 + i);
                            glBindTexture(GL_TEXTURE_2D, material->textures[i]->getTexture());
                            //glUniform1i(material->texlocations[i], material->textures[i]->getTexture());
                        }
                    }
                }
                
                if(!currentMaterial || currentMaterial->culling != material->culling)
                {
                    if(material->culling)
                    {
                        glEnable(GL_CULL_FACE);
                        glFrontFace(material->cullMode);
                    }
                    else
                        glDisable(GL_CULL_FACE);
                }
                
                if(!currentMaterial || (currentMaterial->blending != material->blending || currentMaterial->blendSource != material->blendSource || currentMaterial->blendDestination != material->blendDestination))
                {
                    if(material->blending)
                    {
                        glEnable(GL_BLEND);
                        glBlendFunc(material->blendSource, material->blendDestination);
                    }
                    else
                        glDisable(GL_BLEND);
                }
                
                currentMaterial = material;
            }
        }
    }
}
