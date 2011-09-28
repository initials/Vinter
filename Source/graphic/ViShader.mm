//
//  ViShader.mm
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViShader.h"
#import "ViViewProtocol.h"
#import "ViKernel.h"

namespace vi
{
    namespace graphic
    {
        shader::shader(std::string vertexFile, std::string fragmentFile)
        {            
            generateShaderFromPaths([NSBundle mainBundle], vertexFile, fragmentFile);
        }
        
        shader::shader(defaultShader shader)
        {
            switch (shader)
            {
                case defaultShaderTexture:
                    generateShaderFromPaths([NSBundle mainBundle], "ViTextureShader.vsh", "ViTextureShader.fsh");
                    break;
                    
                case defaultShaderShape:
                    generateShaderFromPaths([NSBundle mainBundle], "ViShapeShader.vsh", "ViShapeShader.fsh");
                    break;
                    
                default:
                    throw "Unknown default shader!";
                    break;
            }
        }
        
        
        
        void shader::generateShaderFromPaths(NSBundle *bundle, std::string vertexFile, std::string fragmentFile)
        {
            matProj = -1;
            matView = -1;
            matModel = -1;
            matProjViewModel = -1;
            
            position = -1;
            texcoord0 = -1;
            texcoord1 = -1;
            
            program = -1;
            
            NSString *vFile = [NSString stringWithUTF8String:vertexFile.c_str()];
            NSString *fFile = [NSString stringWithUTF8String:fragmentFile.c_str()];
            
            NSString *vertexPath = nil;
            NSString *fragmentPath = nil;
            
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
            vertexPath = [bundle pathForResource:[[vFile stringByDeletingPathExtension] stringByAppendingString:@"_iOS"]
                                          ofType:[vFile pathExtension]];
            
            fragmentPath = [bundle pathForResource:[[fFile stringByDeletingPathExtension] stringByAppendingString:@"_iOS"]
                                            ofType:[fFile pathExtension]];
#endif
            
            if(!vertexPath)
                vertexPath = [bundle pathForResource:[vFile stringByDeletingPathExtension] ofType:[vFile pathExtension]];
            
            if(!fragmentPath)
                fragmentPath = [bundle pathForResource:[fFile stringByDeletingPathExtension] ofType:[fFile pathExtension]];
            
            if(!vertexPath || !fragmentPath)
            {
                throw "Vertex or fragment shader not found!";
            }
            
            bool result = create(vertexPath, fragmentPath);
            if(!result)
                throw "Failed to create shader!";
        }
        
        
        void shader::getUniforms()
        {            
            matProj = glGetUniformLocation(program, "matProj");
            matView = glGetUniformLocation(program, "matView");
            matModel = glGetUniformLocation(program, "matModel");
            matProjViewModel = glGetUniformLocation(program, "matProjViewModel");
            
            position = glGetAttribLocation(program, "vertPos");
            texcoord0 = glGetAttribLocation(program, "vertTexcoord0");
            texcoord1 = glGetAttribLocation(program, "vertTexcoord1");
        }
        
        
        
        bool shader::linkProgram()
        {
            GLint status, length;
            
            glLinkProgram(program);
            
            glGetProgramiv(program, GL_INFO_LOG_LENGTH, &length);
            glGetProgramiv(program, GL_LINK_STATUS, &status);
            
            if(length > 0)
            {
                GLchar *log = (GLchar *)malloc(length);
                glGetProgramInfoLog(program, length, &length, log);
                
                ViLog(@"Program link log:\n %s", log);
                free(log);
            }
            
            if(status == 0)
                return false;
            
            return true;
        }
        
        
        bool shader::compileShader(GLuint *shader, GLenum type, NSString *path)
        {
            GLint status, length;
            const GLchar *source = NULL;
            NSString *data = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            
            
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
            uint32_t glslVersion = [ViViewGetActiveView() glslVersion];
            data = [NSString stringWithFormat:@"#version %i\n%@", glslVersion, data];
#endif
            
            source = [data UTF8String];          
            if(!source)
                return false;
            
            *shader = glCreateShader(type);
            glShaderSource(*shader, 1, &source, NULL);
            glCompileShader(*shader);
            
            glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &length);
            glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
            if(length > 0)
            {
                GLchar *log = (GLchar *)malloc(length);
                glGetShaderInfoLog(*shader, length, &length, log);
                
                ViLog(@"%@: Shader compile log:\n%s", path, log);
                free(log);
            }
            
            if(status == 0)
                return false;
            
            return true;
        }
        
        bool shader::create(NSString *vertexPath, NSString *fragmentPath)
        {
            GLuint vertexShader = -1;
            GLuint fragmentShader = -1;
            
            program = glCreateProgram();
            if(program == -1)
            {
                ViLog(@"Failed to create program!");
                return false;
            }
            
            if(!compileShader(&vertexShader, GL_VERTEX_SHADER, vertexPath))
            {
                ViLog(@"Failed to create vertex shader!");
                return false;
            }
            
            if(!compileShader(&fragmentShader, GL_FRAGMENT_SHADER, fragmentPath))
            {
                ViLog(@"Failed to create fragment shader!");
                return false;
            }
            
            
            glAttachShader(program, vertexShader);
            glAttachShader(program, fragmentShader);
            
            if(!linkProgram())
            {
                ViLog(@"Failed to link program!");
                
                if(vertexShader != -1)
                {
                    glDeleteShader(vertexShader);
                    glDetachShader(program, vertexShader);
                }
                
                if(fragmentShader != -1)
                {
                    glDeleteShader(fragmentShader);
                    glDetachShader(program, fragmentShader);
                }
                
                if(program != -1)
                    glDeleteProgram(program);
                
                return false;
            }
            
            if(vertexShader != -1)
            {
                glDeleteShader(vertexShader);
                glDetachShader(program, vertexShader);
            }
            
            if(fragmentShader != -1)
            {
                glDeleteShader(fragmentShader);
                glDetachShader(program, fragmentShader);
            }
            
            getUniforms();
            vi::common::kernel::sharedKernel()->checkError();
            
            return true;
        }
    }
}
