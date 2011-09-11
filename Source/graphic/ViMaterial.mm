//
//  ViMaterial.mm
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViMaterial.h"

namespace vi
{
    namespace graphic
    {
        material::material(vi::graphic::texture *texture, vi::graphic::shader *tshader)
        {
            this->loadDefaultSettings();
            if(texture)
            {
                textures.push_back(texture);
                texlocations.push_back(0);
            }
            
            drawMode = GL_TRIANGLES;
            shader = tshader;
        }
        
        
        void material::loadDefaultSettings()
        {
            shader = NULL;
            culling = true;
            cullMode = GL_CCW;
            
            blending = false;
            blendSource = GL_ONE;
            blendDestination = GL_ONE_MINUS_SRC_ALPHA; 
            
            ambient = vi::graphic::color(0.2f, 0.2f, 0.2f, 1.0f);
            diffuse = vi::graphic::color(0.8f, 0.8f, 0.8f, 1.0f);
            specular = vi::graphic::color(0.0f, 0.0f, 0.0f, 1.0f);
            emissive = vi::graphic::color(0.0f, 0.0f, 0.0f, 1.0f);
        }
        
        
        
        bool material::addParameter(std::string const& name, void *data, materialParameterType type, uint32_t count, uint32_t size)
        {
            if(!shader)
            {
                ViLog(@"Trying to add custom shader parameter without a shader!");
                return NULL;
            }
            
            materialParameter param = materialParameter();
            param.location = glGetUniformLocation(shader->program, name.c_str());
            
            if(param.location == -1)
                return false;
            
            
            param.name = name;
            param.data = data;
            param.type = type;
            param.size = size;
            param.count = count;
            
            parameter.push_back(param);
            return true;
        }
    }
}
