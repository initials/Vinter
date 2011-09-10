//
//  ViSceneNode.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import <Foundation/Foundation.h>
#import "ViMesh.h"
#import "ViVector2.h"
#import "ViCamera.h"
#import "ViMatrix4x4.h"

namespace vi 
{
    namespace common
    {
        class quadtree;
        class matrix4x4;
    }
    
    namespace graphic
    {
        class renderer;
        class material;
    }
    
    namespace scene
    {
        enum
        {
            sceneNodeFlagNoclip = 1
        };
        
        class sceneNode
        {
            friend class vi::common::quadtree;
        public:
            sceneNode(vi::common::vector2 const& pos=vi::common::vector2(), vi::common::vector2 const& tsize=vi::common::vector2(), uint32_t tlayer = 0);
            ~sceneNode();
            
            
            virtual void visit(double timestep);

            void setPosition(vi::common::vector2 const& point);
            void setSize(vi::common::vector2 const& tsize);
            void setFlags(uint32_t flags);
            
            vi::common::vector2 getPosition();
            vi::common::vector2 getSize();
            uint32_t getFlags();
            
            
            GLfloat rotation;
            uint32_t layer;
            
            vi::common::mesh *mesh;
            vi::graphic::material *material;
            
            vi::common::matrix4x4 matrix;
            vi::scene::camera *noPass;
            
        protected:
            vi::common::vector2 position;
            vi::common::vector2 size;
            uint32_t flags;
            
        private:
            vi::common::quadtree *tree;
        };
    }
}