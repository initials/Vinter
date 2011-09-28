//
//  ViTexturePVR.mm
//  Vinter2D
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import <CoreFoundation/CoreFoundation.h>
#import "ViTexturePVR.h"
#import "ViDataPool.h"

namespace vi
{
    namespace graphic
    {
        enum 
        {
            PVRTextureFlagMipmap            = (1 << 8),		// has mip map levels
            PVRTextureFlagTwiddle           = (1 << 9),		// is twiddled
            PVRTextureFlagBumpmap           = (1 << 10),	// has normals encoded for a bump map
            PVRTextureFlagTiling            = (1 << 11),	// is bordered for tiled pvr
            PVRTextureFlagCubemap           = (1 << 12),	// is a cubemap/skybox
            PVRTextureFlagFalseMipCololor	= (1 << 13),	// are there false coloured MIP levels
            PVRTextureFlagVolume            = (1 << 14),	// is this a volume texture
            PVRTextureFlagAlpha             = (1 << 15),	// v2.1 is there transparency info in the texture
            PVRTextureFlagVerticalFlip      = (1 << 16),	// v2.1 is the texture vertically flipped
        };
        
        enum
        {
            PVRPixelFormatRGBA4444 = 0x10,
            PVRPixelFormatRGBA5551,
            PVRPixelFormatRGBA8888,
            PVRPixelFormatRGB565,
            PVRPixelFormatRGB555, // unsupported
            PVRPixelFormatRGB888, // unsupported
            PVRPixelFormatI8,
            PVRPixelFormatAI88,
            PVRPixelFormatPVRTC2,
            PVRPixelFormatPVRTC4,	
            PVRPixelFormatBGRA8888,
            PVRPixelFormatA8,
        };
    
        
        typedef struct
        {
            uint32_t headerLength;
            uint32_t height;
            uint32_t width;
            uint32_t numMipmaps;
            uint32_t flags;
            uint32_t dataLength;
            uint32_t bpp;
            uint32_t bitmaskRed;
            uint32_t bitmaskGreen;
            uint32_t bitmaskBlue;
            uint32_t bitmaskAlpha;
            uint32_t pvrTag;
            uint32_t numSurfs;
        } PVRTextureHeader;
        
        
        
        enum 
        {
            FormatTablePVRTextureFormat,
            FormatTableOpenGLInternalFormat,
            FormatTableOpenGLFormat,
            FormatTableOpenGLType,
            FormatTableBPP,
            FormatTableCompressedImage,
            FormatTablePixelFormat,
        };
        
        static const char PVRMagicNumber[5] = "PVR!";
        static const uint32_t PVRFormatTable[][7] = 
        {
            // PVR Formt             // Internal OGL    // OGL              // OGL Type                 // BPP // Compression // Texture format
            {PVRPixelFormatRGBA8888, GL_RGBA,           GL_RGBA,            GL_UNSIGNED_BYTE,			32, false, vi::graphic::textureFormatRGBA8888},
            {PVRPixelFormatRGBA4444, GL_RGBA,           GL_RGBA,            GL_UNSIGNED_SHORT_4_4_4_4,	16, false, vi::graphic::textureFormatRGBA4444},
            {PVRPixelFormatRGBA5551, GL_RGBA,           GL_RGBA,            GL_UNSIGNED_SHORT_5_5_5_1,	16, false, vi::graphic::textureFormatRGBA5551},
            {PVRPixelFormatRGB565,	GL_RGB,             GL_RGB,             GL_UNSIGNED_SHORT_5_6_5,	16, false, vi::graphic::textureFormatRGB565},
            {PVRPixelFormatAI88,	GL_LUMINANCE_ALPHA, GL_LUMINANCE_ALPHA, GL_UNSIGNED_BYTE,           16,	false, vi::graphic::textureFormatAI88},
            {PVRPixelFormatA8,		GL_ALPHA,           GL_ALPHA,           GL_UNSIGNED_BYTE,			8,	false, vi::graphic::textureFormatA8},
            {PVRPixelFormatI8,		GL_LUMINANCE,       GL_LUMINANCE,       GL_UNSIGNED_BYTE,			8,	false, vi::graphic::textureFormatI8},
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
            {PVRPixelFormatPVRTC4,	GL_COMPRESSED_RGBA_PVRTC_4BPPV1_IMG, -1, -1,                        4,	true, vi::graphic::textureFormatPVRTC4},
            {PVRPixelFormatPVRTC2,	GL_COMPRESSED_RGBA_PVRTC_2BPPV1_IMG, -1, -1,                        2,	true, vi::graphic::textureFormatPVRTC2},
#endif
        };
        
#define PVRFormatTableSize (sizeof(PVRFormatTable) / sizeof(PVRFormatTable[0]))
        
        texturePVR::texturePVR(std::string name) : vi::graphic::texture(0, 0, 0)
        {
            std::string _path = vi::common::dataPool::pathForFile(name);
            
            if(_path.length() == 0)
                throw "No such file found!";
                
            NSString *path = [NSString stringWithUTF8String:_path.c_str()];
            NSData *data = [NSData dataWithContentsOfFile:path];
            
            scaleFactor = ([[path lastPathComponent] rangeOfString:@"@2x"].location != NSNotFound) ? 2.0f : 1.0f;
            generateTextureFromPVRData([data bytes], [data length]);
        }
        
        bool texturePVR::generateTextureFromPVRData(const void *data, size_t length)
        {
            PVRTextureHeader *header;
            uint32_t flags, pvrTag;
            uint32_t dataLength = 0, dataOffset = 0, dataSize = 0, bpp = 4;
            uint32_t blockSize = 0, widthBlocks = 0, heightBlocks = 0;
            uint32_t _width, _height;
            uint32_t formatFlags, formatIndex;
            uint8_t *bytes = NULL;
            
            
            header = (PVRTextureHeader *)data;
            pvrTag = CFSwapInt32LittleToHost(header->pvrTag);
            
            if((uint32_t)PVRMagicNumber[0] != ((pvrTag >>  0) & 0xFF) || (uint32_t)PVRMagicNumber[1] != ((pvrTag >>  8) & 0xFF) ||
               (uint32_t)PVRMagicNumber[2] != ((pvrTag >> 16) & 0xFF) || (uint32_t)PVRMagicNumber[3] != ((pvrTag >> 24) & 0xFF))
            {
                return false;
            }
            
            
            flags = CFSwapInt32LittleToHost(header->flags);
            formatFlags = flags & 0xFF;
            bool success = false;
            
            for(formatIndex=0; formatIndex<(uint32_t)PVRFormatTableSize; formatIndex++) 
            {
                if(PVRFormatTable[formatIndex][FormatTablePVRTextureFormat] == formatFlags)
                {
                    mipMaps = 0;
                    _width = width = CFSwapInt32LittleToHost(header->width);
                    _height = height = CFSwapInt32LittleToHost(header->height);
                    
                    containsAlpha = (CFSwapInt32LittleToHost(header->bitmaskAlpha));
                    
                    
                    bytes = ((uint8_t *)data) + sizeof(PVRTextureHeader);
                    dataLength = CFSwapInt32LittleToHost(header->dataLength);
                    bpp = PVRFormatTable[formatIndex][FormatTableBPP];
                    
                    while(dataOffset < dataLength)
                    {
                        switch(formatFlags) 
                        {
                            case PVRPixelFormatPVRTC2:
                                blockSize = 8 * 4;
                                widthBlocks = width / 8;
                                heightBlocks = height / 4;
                                break;
                                
                            case PVRPixelFormatPVRTC4:
                                blockSize = 4 * 4;
                                widthBlocks = width / 4;
                                heightBlocks = height / 4;
                                break;
                                
                            default:
                                blockSize = 1;
                                widthBlocks = width;
                                heightBlocks = height;
                                break;
                        }
                        
                        if(widthBlocks < 2)
                            widthBlocks = 2;
                        
                        if(heightBlocks < 2)
                            heightBlocks = 2;
                        
                        dataSize = widthBlocks * heightBlocks * ((blockSize  * bpp) / 8);
                        
                        mipMap[mipMaps].address = bytes + dataOffset;
                        mipMap[mipMaps].length = dataSize;
                        
                        mipMaps ++;
                        dataOffset += dataSize;
                        
                        width = MAX(width >> 1, 1);
                        height = MAX(height >> 1, 1);
                    }
                    
                    success = true;
                    break;
                }
            }
            
            if(success)
            {               
                width = _width;
                height = _height;
                
                GLenum internalFormat = PVRFormatTable[formatIndex][FormatTableOpenGLInternalFormat];
                GLenum format = PVRFormatTable[formatIndex][FormatTableOpenGLFormat];
                GLenum type = PVRFormatTable[formatIndex][FormatTableOpenGLType];
                bool compressed = PVRFormatTable[formatIndex][FormatTableCompressedImage];
            
                glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
                
                glGenTextures(1, &name);
                glBindTexture(GL_TEXTURE_2D, name);
                
                if(mipMaps > 1)
                {
                    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
                    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
                }
                else
                {
                    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
                    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
                }
                
                for(GLint i=0; i<mipMaps; i++)
                {
                    texturePVRMipMap mMap = mipMap[i];
                    
                    if(compressed)
                    {
                        glCompressedTexImage2D(GL_TEXTURE_2D, i, internalFormat, _width, _height, 0, mMap.length, mMap.address);
                    }
                    else 
                    {
                        glTexImage2D(GL_TEXTURE_2D, i, internalFormat, _width, _height, 0, format, type, mMap.address);
                    }
                    
                    _width = MAX(_width >> 1, 1);
                    _height = MAX(_height >> 1, 1);
                }
            }
            
            return success;
        }
    }
}
