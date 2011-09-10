//
//  ViSceneNode.mm
//  Vinter
//
//  Copyright 2011 by Nils Daumann Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViSceneNode.h"
#import "ViQuadtree.h"
#import "ViRenderer.h"
#import "ViVector3.h"

namespace vi
{
    namespace scene
    {
        sceneNode::sceneNode(vi::common::vector2 const& pos, vi::common::vector2 const& tsize, uint32_t tlayer)
        {
            position = pos;
            size = tsize;
            layer = tlayer;
            rotation = 0.0;
            
            flags = 0;

            material = NULL;
            
            noPass = NULL;
            tree = NULL;
        }
        
        sceneNode::~sceneNode()
        {
            if(tree)
                tree->removeObject(this);
        }
        
        void sceneNode::visit(double timestep)
        {
            matrix.makeIdentity();
            matrix.translate(vi::common::vector3(position.x, - position.y - size.y, 0.0));
			matrix.rotate(vi::common::vector3(0.0, rotation, 0.0));
        }
        
        
        
        vi::common::vector2 sceneNode::getPosition()
        {
            return position;
        }
        
        void sceneNode::setPosition(vi::common::vector2 const& point)
        {
            if(point.x != position.x || point.y != position.y)
            {
                position = point;
                
                if(tree)
                    tree->updateObject(this);
            }
        }
        
        
        vi::common::vector2 sceneNode::getSize()
        {
            return size;
        }
        
        void sceneNode::setSize(vi::common::vector2 const& tsize)
        {
            if(size != tsize)
            {
                size = tsize;
                
                if(tree)
                    tree->updateObject(this);
            }
        }
        

        uint32_t sceneNode::getFlags()
        {
            return flags;
        }
        
        void sceneNode::setFlags(uint32_t tflags)
        {
            if(flags != tflags)
            {
                uint32_t oldFlags = flags;
                flags = tflags;
                
                if(tree && (oldFlags & sceneNodeFlagNoclip || flags & sceneNodeFlagNoclip))
                    tree->updateObject(this);
            }
            
        }
    }
}
