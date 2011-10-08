//
//  ViSceneNode.mm
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
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
            mesh = NULL;
            
            noPass = NULL;
            tree = NULL;
            parent = NULL;
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
            
            if(rotation > kViEpsilonFloat)
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
                update();
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
                update();
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
                flags = tflags;                
                update();
            }
            
        }
        
        
        void sceneNode::update()
        {
            if((flags & sceneNodeFlagDynamic) && knownDynamic)
                return;
                
            if(tree)
            {
                knownDynamic = (flags & sceneNodeFlagDynamic);
                tree->updateObject(this);
            }
            else
                knownDynamic = false;
        }
        
        
        bool sceneNode::hasChilds()
        {
            return (childs.size() > 0);
        }
        
        std::vector<vi::scene::sceneNode *> *sceneNode::getChilds()
        {
            return &childs;
        }
        
        void sceneNode::addChild(vi::scene::sceneNode *child)
        {
            if(child->parent)
                child->parent->removeChild(child);
            
            childs.push_back(child);
            child->parent = this;
        }
        
        void sceneNode::removeChild(vi::scene::sceneNode *child)
        {
            if(child->parent != this)
                return;
            
            std::vector<vi::scene::sceneNode *>::iterator iterator;
            for(iterator=childs.begin(); iterator!=childs.end(); iterator++)
            {
                if(*iterator == child)
                {
                    child->parent = NULL;
                    childs.erase(iterator);
                    break;
                }
            }
        }
    }
}
