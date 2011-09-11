//
//  ViRendererOSX.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViBase.h"
#import "ViRenderer.h"
#import "ViScene.h"
#import "ViCamera.h"
#import "ViMesh.h"

namespace vi
{
    namespace graphic
    {
        typedef void (*viUniformIv)(GLint, GLsizei, const GLint *);
        typedef void (*viUniformFv)(GLint, GLsizei, const GLfloat *);
        typedef void (*viUniformMatrixFv)(GLint, GLsizei, GLboolean, const GLfloat *);
        
        /**
         * @brief Mac OS X and iOS shader based renderer
         *
         * A shader based renderer capable of rendering under OpenGL 2.x, 3.2 and OpenGL ES 2.0
         **/
        class rendererOSX : public renderer
        {
        public:
            /**
             * Constructor
             **/
            rendererOSX();
            
            /**
             * Renders the given scene with the given camera. See vi::graphic::renderer for more details.
             **/
            virtual void renderSceneWithCamera(vi::scene::scene *scene, vi::scene::camera *camera);
            
        private:
            void renderNode(vi::scene::sceneNode *node);
            void setMaterial(vi::graphic::material *material);
            
            viUniformIv uniformIvFuncs[4];
            viUniformFv uniformFvFuncs[4];
            viUniformMatrixFv uniformMatrixFvFuncs[3];
            
            vi::scene::camera *currentCamera;
            vi::graphic::material *currentMaterial;
        };
    }
}
