//
//  ViScene.m
//  Vinter
//
//  Copyright 2011 by Nils Daumann Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViScene.h"
#import "ViQuadtree.h"
#import "ViRect.h"

namespace vi
{
    namespace scene
    {
        scene::scene(float minX, float minY, float maxX, float maxY, uint32_t subdivisions)
        {
            assert(maxX > minX);
            assert(maxY > minY);
            
            vi::common::rect rect = vi::common::rect(minX, minY, maxX-minX, maxY-minY);
            quadtree = new vi::common::quadtree(rect, subdivisions);
        }
        
        scene::~scene()
        {
            delete quadtree;
        }
        
        
        
        void scene::addNode(vi::scene::sceneNode *node)
        {
            quadtree->insertObject(node);
        }
        
        void scene::removeNode(vi::scene::sceneNode *node)
        {
            quadtree->removeObject(node);
        }
        
        
        void scene::deleteAllNodes()
        {
            quadtree->deleteAllObjects();
        }
        
        
        std::vector<vi::scene::sceneNode *> scene::nodesInRect(vi::common::rect const& rect)
        {
            return quadtree->objectsInRect(rect);
        }
    }
}

