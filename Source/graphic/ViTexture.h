//
//  ViTexture.h
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
        class texture
        {
        public:
            texture(GLuint _name=-1, uint32_t _width=128, uint32_t _height=128);
            texture(std::string name);
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
            texture(NSImage *image);
#endif
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
            texture(UIImage *image);
#endif
            ~texture();
            
            GLuint getTexture();
            
            uint32_t getWidth();
            uint32_t getHeight();
            
        private:         
            void generateTextureFromImage(CGImageRef imageRef);
            
            BOOL ownsHandle;
            GLuint name;
            uint32_t width, height;
        };
    }
}
