//
//  ViShader.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#include <string>
#import "ViBase.h"

namespace vi
{
    namespace graphic
    {
        /**
         * Default shader enums
         **/
        typedef enum
        {
            defaultShaderTexture /** <Texture shader**/,
            defaultShaderShape /** <Shape shader**/
        } defaultShader;
        
        /**
         * @brief Wrapper for an OpenGL program
         *
         * A shader wraps an OpenGL program that is compiled from a vertex and fragment shader file. It also automatically gets commonly used uniforms
         * from the shader (for example the projection matrix or the ambient color) which will then be set by the renderer (for custom shader variables,
         * look into the vi::graphic::material class). The shader class also abstracts things like the GSlang version, you don't have to put #version X
         * into your shaders, the shader will do this automatically for you (X being 120 normally and 150 if you use a OpenGL 3.2 Core Profile renderer).
         **/
        class shader
        {
        public:
            /**
             * Constructor for a shader loaded from disk.
             * @param vertexFile The name and extension of the vertex file. On iOS, the shader will first look for an resource with "_iOS" appended to the name
             * @param fragmentFile The name and extension of the fragment file. On iOS, the shader will first look for an resource with "_iOS" appended to the name
             **/
            shader(std::string vertexFile, std::string fragmentFile);
            /**
             * Constructor for a builtin shader
             * @remark If you didn't added the "Shader" folder to your project or Xcode didn't copied the shader files to the projects bundle, this constructor will fail.
             **/
            shader(defaultShader shader=defaultShaderTexture);
            
            /**
             * Handle to the OpenGL program
             **/
            GLuint program;
        
            /**
             * Projection matrix location.
             * @remark The shader will automatically get the location if you add a variable with the name matProj into your shader.
             **/
            GLuint matProj;
            /**
             * View matrix location.
             * @remark The shader will automatically get the location if you add a variable with the name matView into your shader.
             **/
            GLuint matView;
            /**
             * Model matrix location.
             * @remark The shader will automatically get the location if you add a variable with the name matModel into your shader.
             **/
            GLuint matModel;
            /**
             * Projection * View * Model matrix location.
             * @remark The shader will automatically get the location if you add a variable with the name matProjViewModel into your shader.
             **/
            GLuint matProjViewModel;
            
            /**
             * The vertex position 2D Vector.
             * @remark The shader will automatically get the location if you add a variable with the name vertPos into your shader.
             **/
            GLuint position;
            /**
             * The first texture coordinate 2D Vector.
             * @remark The shader will automatically get the location if you add a variable with the name vertTexcoord0 into your shader.
             **/
            GLuint texcoord0;
            /**
             * The second texture coordinate 2D Vector.
             * @remark The shader will automatically get the location if you add a variable with the name vertTexcoord1 into your shader.
             **/
            GLuint texcoord1;
            
        private:
            bool create(NSString *vertexPath, NSString *fragmentPath);
            bool compileShader(GLuint *shader, GLenum type, NSString *path);
            bool linkProgram();
            
            void generateShaderFromPaths(NSBundle *bundle, std::string vertexFile, std::string fragmentFile);
            void getUniforms();
        };
    }
}
