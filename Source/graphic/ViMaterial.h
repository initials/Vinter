//
//  ViMaterial.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#include <vector>
#include <string>
#import <Foundation/Foundation.h>
#import "ViBase.h"
#import "ViTexture.h"
#import "ViShader.h"

namespace vi
{
    namespace scene
    {
        class renderer;
    }
    
    namespace graphic
    {
        typedef enum
        {
            materialParameterTypeInt,
            materialParameterTypeFloat,
            materialParameterTypeMatrix
        } materialParameterType;
        
        class materialParameter
        {
        public:
            std::string name;
            GLuint location;
            
            void *data;
            materialParameterType type;
            uint32_t count;
            uint32_t size;
        };
        
        class material
        {
        public:
            material(vi::graphic::texture *texture=NULL, vi::graphic::shader *tshader=NULL);
            
            bool addParameter(std::string const& name, void *data, materialParameterType type, uint32_t count, uint32_t size);
            
            GLenum drawMode;
            
            bool culling;
            GLenum cullMode;
            
            bool blending;
            GLenum blendSource;
            GLenum blendDestination;
            
            std::vector<vi::graphic::texture *> textures;
            std::vector<uint32_t> texlocations;
            std::vector<materialParameter> parameter;
            
            vi::graphic::shader *shader;
            
        private:
            void loadDefaultSettings();
        };
    }
}