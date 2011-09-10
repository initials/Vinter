//
//  ViCamera.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import <Foundation/Foundation.h>
#import "ViViewProtocol.h"
#import "ViMatrix4x4.h"
#import "ViTexture.h"
#import "ViColor.h"
#import "ViRect.h"
#import "ViVector2.h"

namespace vi
{
    namespace scene
    {
        class camera
        {
        public:
            camera(id<ViViewProtocol> tview=NULL, vi::common::vector2 const& size=vi::common::vector2());
            ~camera();

            void bind();
            void unbind();
            
            vi::common::rect frame;
            vi::common::matrix4x4 projectionMatrix;
            vi::common::matrix4x4 viewMatrix;
            
            vi::graphic::color clearColor;
            vi::graphic::texture *getTexture();
            
        private:
            id<ViViewProtocol> view;
            
            GLuint target;
            GLuint framebuffer;
            GLint  prevBuffer;
            vi::graphic::texture *texture;
        };
    }
}
