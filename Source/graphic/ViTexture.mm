//
//  ViTexture.mm
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViTexture.h"

namespace vi
{
    namespace graphic
    {
        texture::texture(GLuint _name, uint32_t _width, uint32_t _height)
        {
            width = _width;
            height = _height;
            
            if(_name == -1 || !glIsTexture(_name))
            {
                GLubyte *data = (GLubyte *)calloc(1, width * height * 4);
                
                glGenTextures(1, &name);
                glBindTexture(GL_TEXTURE_2D, name);
                
                glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
                glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
                glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
                
                free(data);
                ownsHandle = true;
            }
            else
            {
                name = _name;
                ownsHandle = false;
            }
        }
        
        texture::texture(std::string name)
        {
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
            NSImage *image = [NSImage imageNamed:[NSString stringWithUTF8String:name.c_str()]];
            
            CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)[image TIFFRepresentation], NULL);
            CGImageRef imageRef =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
            
            generateTextureFromImage(imageRef);
            
            CFRelease(source);
            CFRelease(imageRef);
#endif
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
            UIImage *image = [UIImage imageNamed:[NSString stringWithUTF8String:name.c_str()]];
            generateTextureFromImage([image CGImage]);
#endif
        }
        
        texture::texture(CGImageRef image)
        {
            generateTextureFromImage(image);
        }
        
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
        texture::texture(NSImage *image)
        {
            if(!image)
                throw "Trying to generate a texture from nothing!";
            
            CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)[image TIFFRepresentation], NULL);
            CGImageRef imageRef =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
            
            generateTextureFromImage(imageRef);
            
            CFRelease(source);
            CFRelease(imageRef);
        }
#endif
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
        texture::texture(UIImage *image)
        {
            if(!image)
                throw "Trying to generate a texture from nothing!";
            
            generateTextureFromImage([image CGImage]);
        }
#endif
        
        void texture::generateTextureFromImage(CGImageRef imageRef)
        {
            width = (uint32_t)CGImageGetWidth(imageRef);
            height = (uint32_t)CGImageGetHeight(imageRef);
            
            GLubyte *data = (GLubyte *)calloc(1, width * height * 4);
            CGContextRef context = CGBitmapContextCreate(data, width, height, 8, width * 4, CGImageGetColorSpace(imageRef), kCGImageAlphaPremultipliedLast);
            
            CGContextDrawImage(context, CGRectMake(0.0, 0.0, (float)width, (float)height), imageRef);
            
            
            glGenTextures(1, &name);
            glBindTexture(GL_TEXTURE_2D, name);
            
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
            
            free(data);
            CFRelease(context);
            
            ownsHandle = true;
        }
        
        texture::~texture()
        {
            if(ownsHandle)
                glDeleteTextures(1, &name);
        }
        
        
        GLuint texture::getTexture()
        {
            return name;
        }
        
        uint32_t texture::getWidth()
        {
            return width;
        }
        
        uint32_t texture::getHeight()
        {
            return height;
        }
    };
}
