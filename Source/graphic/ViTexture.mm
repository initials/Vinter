//
//  ViTexture.mm
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViTexture.h"
#import "ViDataPool.h"

namespace vi
{
    namespace graphic
    {
        static vi::graphic::textureFormat defaultAlphaFormat = textureFormatRGBA8888;
        
        
        texture::texture(GLuint _name, uint32_t _width, uint32_t _height)
        {
            width = _width;
            height = _height;
            
            if(_name == -1)
            {
                GLubyte *data = (GLubyte *)calloc(1, width * height * 4);
                
                glGenTextures(1, &name);
                glBindTexture(GL_TEXTURE_2D, name);
                
                glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
                glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
                
                glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
                
                free(data);
                ownsHandle = true;
                containsAlpha = true;
            }
            else
            {
                name = _name;
                ownsHandle = false;
                containsAlpha = false;
            }
        }
        
        texture::texture(std::string name)
        {
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
            NSImage *image = [NSImage imageNamed:[NSString stringWithUTF8String:name.c_str()]];
            if(!image)
                throw "No such image found!";
            
            CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)[image TIFFRepresentation], NULL);
            CGImageRef imageRef =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
            
            generateTextureFromImage(imageRef, 1.0f);
            
            CFRelease(source);
            CFRelease(imageRef);
#endif
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
            UIImage *image = [UIImage imageNamed:[NSString stringWithUTF8String:name.c_str()]];
            if(!image)
                throw "No such image found!";
            
            float scale = 1.0f;
            if([image respondsToSelector:@selector(scale)])
                scale = [image scale];
            
            generateTextureFromImage([image CGImage], scale);
#endif
        }
        
        texture::texture(CGImageRef image, float factor)
        {
            generateTextureFromImage(image, factor);
        }
        
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
        texture::texture(NSImage *image)
        {
            if(!image)
                throw "Trying to generate a texture from nothing!";
            
            CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)[image TIFFRepresentation], NULL);
            CGImageRef imageRef =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
            
            generateTextureFromImage(imageRef, 1.0f);
            
            CFRelease(source);
            CFRelease(imageRef);
        }
#endif
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
        texture::texture(UIImage *image)
        {
            if(!image)
                throw "Trying to generate a texture from nothing!";
            
            float scale = 1.0f;
            
            if([image respondsToSelector:@selector(scale)])
                scale = [image scale];
            
            generateTextureFromImage([image CGImage], scale);
        }
#endif
        

        
        void texture::generateTextureFromImage(CGImageRef imageRef, float factor)
        {
            if(!imageRef)
                throw "CGImageRef must not be NULL!";
            
            width = (uint32_t)CGImageGetWidth(imageRef);
            height = (uint32_t)CGImageGetHeight(imageRef);
            scaleFactor = factor;
            
            CGImageAlphaInfo info = CGImageGetAlphaInfo(imageRef);
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGContextRef context = NULL;
            
            containsAlpha = ((info == kCGImageAlphaPremultipliedLast) || (info == kCGImageAlphaPremultipliedFirst) || (info == kCGImageAlphaLast) || (info == kCGImageAlphaFirst));
            size_t bpp = CGImageGetBitsPerComponent(imageRef);
            
            vi::graphic::textureFormat pixelFormat = (containsAlpha || bpp >= 8) ? vi::graphic::defaultAlphaFormat : textureFormatRGB565;            
            void *data = calloc(1, width * height * 4);
            
            
            switch(pixelFormat)
            {
                case textureFormatRGBA8888:
                case textureFormatRGBA4444:
                case textureFormatRGBA5551:
                    info = containsAlpha ? kCGImageAlphaPremultipliedLast : kCGImageAlphaNoneSkipLast;			
                    break;
                    
                case textureFormatRGB565:
                    info = kCGImageAlphaNoneSkipLast;
                    break;
                    
                default:
                    break;
            }
            
            context = CGBitmapContextCreate(data, width, height, 8, width * 4, colorSpace, info | kCGBitmapByteOrder32Big);
            CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
            
            CFRelease(colorSpace);
            
            
            if(pixelFormat == textureFormatRGB565) 
            {
                void *temp = malloc(width * height * 2);
                uint32_t *inPixel32 = (uint32_t *)data;
                uint16_t *outPixel16 = (uint16_t *)temp;
                
                for(uint32_t i=0; i<width * height; ++i, ++inPixel32)
                {
                    *outPixel16++ = ((((*inPixel32 >> 0) & 0xFF) >> 3) << 11) | 
                                    ((((*inPixel32 >> 8) & 0xFF) >> 2) << 5) | 
                                    ((((*inPixel32 >> 16) & 0xFF) >> 3) << 0);
                }
                    
                free(data);
                data = temp;
                
            }
            else if(pixelFormat == textureFormatRGBA4444) 
            {
                void *temp = malloc(width * height * 2);
                uint32_t *inPixel32 = (uint32_t *)data;
                uint16_t *outPixel16 = (uint16_t *)temp;
                
                for(uint32_t i=0; i<width * height; ++i, ++inPixel32)
                {
                    *outPixel16++ = ((((*inPixel32 >> 0) & 0xFF) >> 4) << 12) |
                                    ((((*inPixel32 >> 8) & 0xFF) >> 4) << 8) |
                                    ((((*inPixel32 >> 16) & 0xFF) >> 4) << 4) |
                                    ((((*inPixel32 >> 24) & 0xFF) >> 4) << 0);
                }
                
                free(data);
                data = temp;
            }
            else if(pixelFormat == textureFormatRGBA5551) 
            {
                void *temp = malloc(width * height * 2);
                uint32_t *inPixel32 = (uint32_t *)data;
                uint16_t *outPixel16 = (uint16_t *)temp;
                
                for(uint32_t i=0; i<width*height; ++i, ++inPixel32)
                {
                    *outPixel16++ = ((((*inPixel32 >> 0) & 0xFF) >> 3) << 11) |
                                    ((((*inPixel32 >> 8) & 0xFF) >> 3) << 6) |
                                    ((((*inPixel32 >> 16) & 0xFF) >> 3) << 1) |
                                    ((((*inPixel32 >> 24) & 0xFF) >> 7) << 0);
                }
                
                free(data);
                data = temp;
            }
            
            generateTextureFromData(data, pixelFormat);
            
            CFRelease(context);
            free(data);
        }
        
        void texture::generateTextureFromData(void *data, vi::graphic::textureFormat format)
        {
            GLenum glType;
            GLenum glFormat;
            
            switch(format)
            {
                case textureFormatRGBA8888:
                    glFormat = GL_UNSIGNED_BYTE;
                    glType = GL_RGBA;
                    break;
                    
                case textureFormatRGBA4444:
                    glFormat = GL_UNSIGNED_SHORT_4_4_4_4;
                    glType = GL_RGBA;
                    break;
                    
                case textureFormatRGBA5551:
                    glFormat = GL_UNSIGNED_SHORT_5_5_5_1;
                    glType = GL_RGBA;
                    break;
                    
                case textureFormatRGB565:
                    glFormat = GL_UNSIGNED_SHORT_5_6_5;
                    glType = GL_RGB;
                    
                default:
                    glFormat = GL_UNSIGNED_BYTE;
                    glType = GL_RGBA;
                    break;
            }
            
            glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
            
            glGenTextures(1, &name);
            glBindTexture(GL_TEXTURE_2D, name);
            
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
            
            glTexImage2D(GL_TEXTURE_2D, 0, glType, width, height, 0, glType, glFormat, data);
            
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
            return width / scaleFactor;
        }
        
        uint32_t texture::getHeight()
        {
            return height / scaleFactor;
        }
        
        
        
        void texture::setDefaultFormat(vi::graphic::textureFormat format)
        {
            if(format > textureFormatRGBA5551)
                return;
            
            defaultAlphaFormat = format;
        }
    };
}
