//
//  ViRendererOSX.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import <Foundation/Foundation.h>
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
        
        
        class rendererOSX : public renderer
        {
        public:
            rendererOSX();
            
            virtual void renderSceneWithCamera(vi::scene::scene *scene, vi::scene::camera *camera);
            
            virtual void renderNode(vi::scene::sceneNode *node);
            virtual void setMaterial(vi::graphic::material *material);

        private:
            viUniformIv uniformIvFuncs[4];
            viUniformFv uniformFvFuncs[4];
            viUniformMatrixFv uniformMatrixFvFuncs[3];
            
            vi::scene::camera *currentCamera;
            vi::graphic::material *currentMaterial;
        };
    }
}
