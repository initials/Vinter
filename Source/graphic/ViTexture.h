//
//  ViTexture.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#include <string>
#import "ViBase.h"

#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
#import <Cocoa/Cocoa.h>
#endif

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#import <UIKit/UIKit.h>
#endif


namespace vi
{
    namespace graphic
    {
        /**
         * @brief A OpenGL texture wrapper
         *
         * A texture wrapps an OpenGL 2D texture and allows you to create textures from images and files.
         **/
        class texture
        {
        public:
            /**
             * Constructor for an empty or already loaded texture, depending on _name
             * @param _name If this is set to something else than -1, the constructor will assume that this is a handle to an already loaded texture!
             * @param _width The width of the texture
             * @param _height The height of the texture
             **/
            texture(GLuint _name=-1, uint32_t _width=128, uint32_t _height=128);
            /**
             * Constructor for an texture which is loaded from the main bundle
             **/
            texture(std::string name);
            /**
             * Constructor for an texture from an Core Graphics image
             **/
            texture(CGImageRef image, float factor=1.0f);
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
            /**
             * Constructor for an texture from an NSImage
             * @param image A valid NSImage, if you pass NULL the constructor will raise an exception
             **/
            texture(NSImage *image);
#endif
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
            /**
             * Constructor for an texture from an UIImage
             * @param image A valid UIImage, if you pass NULL the constructor will raise an exception
             **/
            texture(UIImage *image);
#endif
            ~texture();
            
            /**
             * Returns the handle to the texture
             **/
            GLuint getTexture();
            
            /**
             * Returns the width of the texture
             **/
            uint32_t getWidth();
            /**
             * Returns the height of the texture
             **/
            uint32_t getHeight();
            
        private:         
            void generateTextureFromImage(CGImageRef imageRef, float factor);
            
            BOOL ownsHandle;
            GLuint name;
            
            uint32_t width, height;
            float scaleFactor;
        };
    }
}
