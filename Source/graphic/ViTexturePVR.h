//
//  ViTexturePVR.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#include <string>
#import "ViBase.h"
#import "ViTexture.h"

namespace vi
{
    namespace graphic
    {
        /**
         * The maximum number of mip maps to be loaded from a PVR texture
         **/
        #define ViTexturePVRMaxMipsMaps 32
        
        /**
         * @cond
         **/
        struct texturePVRMipMap
        {
            unsigned char *address;
            unsigned int length;
        };
        /**
         * @endcond
         **/
    
        
        /**
         * @brief A texture subclass that is capable of loading compressed and uncompressed PVR textures.
         *
         * texturePVR is a texture subclass that can load various PVR texture formats with mip maps. 
         * Supported formats are RGBA 8888, RGBA 4444, RGBA 55551, AI88, A8, I8, PVRTC2 and PVRTC4. Use compressed PVR textures wherever possible,
         * they can be loaded compressed into the VRAM and thus take way less space than normal textures which have to be loaded uncompressed into the VRAM.
         **/
        class texturePVR : public vi::graphic::texture
        {
        public:
            /**
             * Constructor
             * @remark The function uses vi::common::dataPool::pathForFile() to get the path for the file.
             **/
            texturePVR(std::string name);
            
        private:
            uint32_t mipMaps;
            texturePVRMipMap mipMap[ViTexturePVRMaxMipsMaps];
            
            
            bool generateTextureFromPVRData(const void *data, size_t length);
        };
    }
}
