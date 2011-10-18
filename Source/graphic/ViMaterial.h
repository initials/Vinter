//
//  ViMaterial.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#include <vector>
#include <string>
#import "ViBase.h"
#import "ViAsset.h"
#import "ViTexture.h"
#import "ViShader.h"
#import "ViColor.h"

namespace vi
{
    namespace graphic
    {
        /**
         * Possible material parameter types
         **/
        typedef enum
        {
            materialParameterTypeInt /** <Specifies an integer type**/,
            materialParameterTypeFloat /** <Specifies an floating point type**/,
            materialParameterTypeMatrix /** <Specifies an floating point matrix type**/
        } materialParameterType;
        
        /**
         * @brief Class that is used to bind custom shader variables to a material
         *
         * A material parameter is used to implement custom shader variables (uniforms). The renderer will pass down the data to the GPU using either
         * glUniformNiv, glUniformNif or glUniformMatrixNfv depending on the type and size.
         **/
        class materialParameter
        {
        public:
            /**
             * The name of the variable
             **/
            std::string name;
            /**
             * The location of the variable.
             **/
            GLuint location;
            
            /**
             * Pointer to the data
             **/
            void *data;
            /**
             * The type of the data
             **/
            materialParameterType type;
            /**
             * The number of elements, this is usually 1 unless you are dealing with an array.
             **/
            uint32_t count;
            /**
             * The size of data. For example, if you wanted to pass a 2x2 matrix, this would be 2. If you want to pass a vec3, this would be 3 etc.
             * @remark If you want to pass a sampler, the size is always 1!
             **/
            uint32_t size;
        };
        
        
        /**
         * @brief Class that represents a rendering material
         * 
         * A material contains information about how to render the scene node that the material is attached to, it also includes custom variables that
         * are send to the attached shader.
         **/
        class material : public vi::common::asset
        {
        public:
            /**
             * Constructor
             * @param texture The texture which should be used at the location 0
             * @param tshader The shader to use with the material. Materials without a shader won't be rendered!
             **/
            material(vi::graphic::texture *texture=NULL, vi::graphic::shader *tshader=NULL);

            /**
             * Adds a new material parameter.
             * @return True if the parameter could be created, otherwise false (this might be the case if there was no such uniform variable in the shader)
             **/
            bool addParameter(std::string const& name, void *data, materialParameterType type, uint32_t count, uint32_t size);

            
            /**
             * The draw mode for the material.
             * Default: GL_TRIANGLES
             **/
            GLenum drawMode;
            
            /**
             * True if the material enables culling, otherwise false.
             * Default: True
             **/
            bool culling;
            /**
             * The cull mode, either GL_CCW or GL_CW.
             * Default: GL_CCW
             **/
            GLenum cullMode;
            
            /**
             * True if the material enables blending, otherwise false.
             * Default: False
             **/
            bool blending;
            /**
             * The blending source.
             * Default: GL_ONE
             **/
            GLenum blendSource;
            /**
             * The blending destination.
             * Default: GL_ONE_MINUS_SRC_ALPHA
             **/
            GLenum blendDestination;
            
            /**
             * Textures in the material
             **/
            std::vector<vi::graphic::texture *> textures;
            /**
             * Location of the textures.
             **/
            std::vector<uint32_t> texlocations;
            /**
             * List of custom shader variables
             **/
            std::vector<materialParameter> parameter;
            
            
            /**
             * The shader object that should be used together with the material
             **/
            vi::graphic::shader *shader;
            
        private:
            void loadDefaultSettings();
        };
    }
}