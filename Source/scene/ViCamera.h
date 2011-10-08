//
//  ViCamera.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

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
        /**
         * @brief A camera is a view into a scene (surprise)
         *
         * A camera can either be used to render into a texture or into a view that implements the ViViewProtocol. To render a view with a camera,
         * you have to add the camera to a valid vi::common::kernel.
         **/
        class camera
        {
        public:
            /**
             * Constructor
             * @param tview The render target view. If set to NULL, the camera will render into a texture instead of an view
             * @param size The size of the camera. Only used if tview is NULL to create a backing texture and framebuffer for the camera.
             **/
            camera(id<ViViewProtocol> tview=NULL, vi::common::vector2 const& size=vi::common::vector2());
            /**
             * Destructor automatically deletes the texture and framebuffer allocated by the view.
             **/
            ~camera();

            /**
             * Binds the camera. This will set the glViewPort, clear the frame buffer and update the matrices.
             **/
            void bind();
            /**
             * Unbinds the camera. If the camera is view based, the camera will unbind the view and trigger its buffer swapping.
             * If the camera renders into a texture, the camera will bind the previously active frame buffer (the one that was active when calling bind())
             **/
            void unbind();
            
            /**
             * The visible frame of the camera.
             **/
            vi::common::rect frame;
            /**
             * The projection matrix. This is automatically set to an orthogonal projection matrix.
             **/
            vi::common::matrix4x4 projectionMatrix;
            /**
             * The view matrix. This is automatically set to a matrix translated by the frames origin.
             **/
            vi::common::matrix4x4 viewMatrix;
            
            /**
             * The clear color. The default is a light blueish color.
             **/
            vi::graphic::color clearColor;
            /**
             * The texture object which the camera renders into.
             * @return Returns a non NULL value only if the camera renders into a texture and not into a view.
             **/
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
