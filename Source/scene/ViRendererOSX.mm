//
//  ViRendererOSX.mm
//  Vinter
//
//  Copyright 2011 by Nils Daumann Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViRendererOSX.h"
#import "ViQuadtree.h"
#import "ViSceneNode.h"
#import "ViVector3.h"

namespace vi
{
    namespace graphic
    {
        rendererOSX::rendererOSX()
        {
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
            
            //glUniformMatrix2fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat *value)
            uniformMatrixFvFuncs[0] = glUniformMatrix2fv;
            uniformMatrixFvFuncs[1] = glUniformMatrix3fv;
            uniformMatrixFvFuncs[2] = glUniformMatrix4fv;
        }
        
       
        
        void rendererOSX::renderSceneWithCamera(vi::scene::scene *scene, vi::scene::camera *camera)
        {
            camera->bind();
            currentCamera = camera;
            
            std::vector<vi::scene::sceneNode *> nodes = scene->nodesInRect(camera->frame);
            std::vector<vi::scene::sceneNode *>::iterator iterator;
            
            for(iterator=nodes.begin(); iterator!=nodes.end(); iterator++)
            {
                vi::scene::sceneNode *node = *iterator;
                
                if(node->noPass == camera)
                    continue;
                
                node->visit(0.0);
                
                this->setMaterial(node->material);
                this->renderNode(node);
            }
            
            camera->unbind();
        }
        
        void rendererOSX::renderNode(vi::scene::sceneNode *node)
        {
            if(!currentMaterial->shader)
            {
                static bool complaintAboutShader = false;
                if(!complaintAboutShader)
                {
                    ViLog(@"Tried to render a node using a shader based renderer but the node has no shader! This error will be reported once");
                    complaintAboutShader = true;
                }
                
                return;
            }
            
            if(!node->mesh)
                return; 
            
            glUseProgram(currentMaterial->shader->program);
            
            if(currentMaterial->shader->matProj != -1)
				glUniformMatrix4fv(currentMaterial->shader->matProj, 1, GL_FALSE, currentCamera->projectionMatrix.matrix);
            
            if(currentMaterial->shader->matView != -1)
                glUniformMatrix4fv(currentMaterial->shader->matView, 1, GL_FALSE, currentCamera->viewMatrix.matrix);
			
            if(currentMaterial->shader->matModel != -1)
                glUniformMatrix4fv(currentMaterial->shader->matModel, 1, GL_FALSE, node->matrix.matrix);
            
            if(currentMaterial->shader->matProjViewModel != -1)
            {
                vi::common::matrix4x4 matProjViewModel = currentCamera->projectionMatrix * currentCamera->viewMatrix * node->matrix;
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
                        uniformIvFuncs[parameter.count - 1](parameter.location, parameter.count, (const GLint *)parameter.data);
                    }
                        break;
                        
                    case vi::graphic::materialParameterTypeFloat:
                    {
                        uniformFvFuncs[parameter.count - 1](parameter.location, parameter.count, (const GLfloat *)parameter.data);
                    }
                        break;
                        
                    case vi::graphic::materialParameterTypeMatrix:
                    {
                        uniformMatrixFvFuncs[parameter.count - 2](parameter.location, parameter.count, GL_FALSE, (const GLfloat *)parameter.data);
                    }
                        break;
                        
                    default:
                        break;
                }
            }
            
            if(node->mesh->vbo == -1)
            {
                glBindBuffer(GL_ARRAY_BUFFER, 0);
                
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
            else
            {
                glBindBuffer(GL_ARRAY_BUFFER, node->mesh->vbo);
                
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
            

            if(node->mesh->ivbo == -1)
			{
				glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
				glDrawElements(currentMaterial->drawMode, node->mesh->indexCount, GL_UNSIGNED_SHORT, node->mesh->indices);
			}
            else
            {
				glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, node->mesh->ivbo);
				glDrawElements(currentMaterial->drawMode, node->mesh->indexCount, GL_UNSIGNED_SHORT, 0);
			}
            
            
            // Reset the arrays
            if(currentMaterial->shader->position != -1)
            {
                glDisableVertexAttribArray(currentMaterial->shader->position);
            }
            
            if(currentMaterial->shader->texcoord0 != -1)
            {
                glDisableVertexAttribArray(currentMaterial->shader->texcoord0);
            }
        }
        
        
        void rendererOSX::setMaterial(vi::graphic::material *material)
        {
            if(!material)
                return;
            
            if(currentMaterial != material)
            {
                if(!currentMaterial || (currentMaterial->textures != material->textures && currentMaterial->texlocations != material->texlocations))
                {
                    if(material->textures.size() > 0)
                    {
                        for(int i=0; i<material->texlocations.size(); i++)
                        {
                            if(material->texlocations[i] == -1)
                                break;
                            
                            glActiveTexture(GL_TEXTURE0 + i);
                            glBindTexture(GL_TEXTURE_2D, material->textures[i]->getTexture());
                            glUniform1i(material->texlocations[i], i);
                        }
                        
                        glEnable(GL_TEXTURE_2D);
                    }
                    else
                        glDisable(GL_TEXTURE_2D);
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
                
                if(!currentMaterial || (currentMaterial->blending != material->blending && currentMaterial->blendSource != material->blendSource && currentMaterial->blendDestination != material->blendDestination))
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
