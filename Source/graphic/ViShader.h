//
//  ViShader.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#include <string>
#import <Foundation/Foundation.h>
#import "ViBase.h"

namespace vi
{
    namespace graphic
    {
        typedef enum
        {
            defaultShaderTexture,
            defaultShaderShape
        } defaultShader;
        
        class shader
        {
        public:
            shader(std::string vertexFile, std::string fragmentFile);
            shader(defaultShader shader=defaultShaderTexture);
            
            GLuint program;
        
            GLuint matProj;
            GLuint matView;
            GLuint matModel;
            GLuint matProjViewModel;
            
            GLuint position;
            GLuint texcoord0;
            GLuint texcoord1;
            GLuint color;
            
        private:
            bool create(NSString *vertexPath, NSString *fragmentPath);
            bool compileShader(GLuint *shader, GLenum type, NSString *path);
            bool linkProgram();
            
            void generateShaderFromPaths(NSBundle *bundle, std::string vertexFile, std::string fragmentFile);
            void getUniforms();
        };
    }
}
