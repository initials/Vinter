//
//  ViTexture.mm
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViTexture.h"
#import "ViDataPool.h"
#import "ViKernel.h"

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
            std::string path = vi::common::dataPool::pathForFile(name);
            
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
            NSImage *image = [[NSImage alloc] initWithContentsOfFile:[NSString stringWithUTF8String:path.c_str()]];
            if(!image)
                throw "No such image found!";
            
            CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)[image TIFFRepresentation], NULL);
            CGImageRef imageRef =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
            
            generateTextureFromImage(imageRef, 1.0f);
            
            CFRelease(source);
            CFRelease(imageRef);
#endif
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithUTF8String:path.c_str()]];
            if(!image)
                throw "No such image found!";
            
            float scale = 1.0f;
            if([image respondsToSelector:@selector(scale)])
                scale = [image scale];
            
            generateTextureFromImage([image CGImage], scale);
#endif
            
            [image release];
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
                uint32_t *inPixel32  = (uint32_t *)data;
                uint16_t *outPixel16 = (uint16_t *)temp;
                uint32_t pixelCount = width * height;
                
#ifdef __ARM_NEON__
                for(uint32_t i=0; i<pixelCount; i+=8, inPixel32+=8, outPixel16+=8)
                {
                    uint8x8x4_t rgba  = vld4_u8((const uint8_t *)inPixel32);
                    
                    uint8x8_t r = vshr_n_u8(rgba.val[0], 3);
                    uint8x8_t g = vshr_n_u8(rgba.val[1], 2);
                    uint8x8_t b = vshr_n_u8(rgba.val[2], 3);
                    
                    uint16x8_t r16 = vmovl_u8(r);
                    uint16x8_t g16 = vmovl_u8(g);
                    uint16x8_t b16 = vmovl_u8(b);
                    
                    r16 = vshlq_n_u16(r16, 11);
                    g16 = vshlq_n_u16(g16, 5);
                    
                    uint16x8_t result = (r16 | g16 | b16);
                    vst1q_u16(outPixel16, result);
                }
#else                
                for(uint32_t i=0; i<pixelCount; i++, inPixel32++)
                {
                    uint32_t r = (((*inPixel32 >> 0)  & 0xFF) >> 3);
                    uint32_t g = (((*inPixel32 >> 8)  & 0xFF) >> 2);
                    uint32_t b = (((*inPixel32 >> 16) & 0xFF) >> 3);
                    
                    *outPixel16++ = (r << 11) | (g << 5) | (b << 0);               
                }
#endif
                    
                free(data);
                data = temp;
            }
            else if(pixelFormat == textureFormatRGBA4444) 
            {
                void *temp = malloc(width * height * 2);
                uint32_t *inPixel32  = (uint32_t *)data;
                uint16_t *outPixel16 = (uint16_t *)temp;
                uint32_t pixelCount = width * height;
                
#ifdef __ARM_NEON__
                for(uint32_t i=0; i<pixelCount; i+=8, inPixel32+=8, outPixel16+=8)
                {
                    uint8x8x4_t rgba  = vld4_u8((const uint8_t *)inPixel32);
                    
                    uint8x8_t r = vshr_n_u8(rgba.val[0], 4);
                    uint8x8_t g = vshr_n_u8(rgba.val[1], 4);
                    uint8x8_t b = vshr_n_u8(rgba.val[2], 4);
                    uint8x8_t a = vshr_n_u8(rgba.val[3], 4);
                    
                    uint16x8_t a16 = vmovl_u8(a);
                    uint16x8_t r16 = vmovl_u8(r);
                    uint16x8_t g16 = vmovl_u8(g);
                    uint16x8_t b16 = vmovl_u8(b);
                    
                    r16 = vshlq_n_u16(r16, 12);
                    g16 = vshlq_n_u16(g16, 8);
                    b16 = vshlq_n_u16(b16, 4);
                    
                    uint16x8_t result = (a16 | r16 | g16 | b16);
                    vst1q_u16(outPixel16, result);
                }
#else                
                for(uint32_t i=0; i<pixelCount; i++, inPixel32++)
                {
                    uint32_t r = (((*inPixel32 >> 0)  & 0xFF) >> 4);
                    uint32_t g = (((*inPixel32 >> 8)  & 0xFF) >> 4);
                    uint32_t b = (((*inPixel32 >> 16) & 0xFF) >> 4);
                    uint32_t a = (((*inPixel32 >> 24) & 0xFF) >> 4);
                    
                    *outPixel16++ = (r << 12) | (g << 8) | (b << 4) | a;
                }
#endif
                
                free(data);
                data = temp;
            }
            else if(pixelFormat == textureFormatRGBA5551) 
            {
                void *temp = malloc(width * height * 2);
                uint32_t *inPixel32  = (uint32_t *)data;
                uint16_t *outPixel16 = (uint16_t *)temp;
                uint32_t pixelCount = width * height;
                
#ifdef __ARM_NEON__
                for(uint32_t i=0; i<pixelCount; i+=8, inPixel32+=8, outPixel16+=8)
                {
                    uint8x8x4_t rgba  = vld4_u8((const uint8_t *)inPixel32);
                    
                    uint8x8_t r = vshr_n_u8(rgba.val[0], 3);
                    uint8x8_t g = vshr_n_u8(rgba.val[1], 3);
                    uint8x8_t b = vshr_n_u8(rgba.val[2], 3);
                    uint8x8_t a = vshr_n_u8(rgba.val[3], 7);
                    
                    uint16x8_t a16 = vmovl_u8(a);
                    uint16x8_t r16 = vmovl_u8(r);
                    uint16x8_t g16 = vmovl_u8(g);
                    uint16x8_t b16 = vmovl_u8(b);
                    
                    r16 = vshlq_n_u16(r16, 11);
                    g16 = vshlq_n_u16(g16, 6);
                    b16 = vshlq_n_u16(b16, 1);
                    
                    uint16x8_t result = (a16 | r16 | g16 | b16);
                    vst1q_u16(outPixel16, result);
                }
#else
                for(uint32_t i=0; i<pixelCount; i++, inPixel32++)
                {
                    uint32_t r = (((*inPixel32 >> 0)  & 0xFF) >> 3);
                    uint32_t g = (((*inPixel32 >> 8)  & 0xFF) >> 3);
                    uint32_t b = (((*inPixel32 >> 16) & 0xFF) >> 3);
                    uint32_t a = (((*inPixel32 >> 24) & 0xFF) >> 7);
                    
                    *outPixel16++ = (r << 11) | (g << 6) | (b << 1) | a;
                }
#endif
                
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
                    break;
                    
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
            
            vi::common::kernel::sharedKernel()->checkError();
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
