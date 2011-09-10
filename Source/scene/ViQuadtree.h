//
//  ViQuadtree.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#include <vector>
#import <Foundation/Foundation.h>
#import "ViRect.h"

namespace vi
{
    namespace scene
    {
        class sceneNode;
    }
    
    namespace common
    {        
        class quadtree
        {
        public:
            quadtree(vi::common::rect const& rect, uint32_t subdivions = 2);
            ~quadtree();
            
            void subdivide();
            vi::common::rect getFrame();
            
            std::vector<vi::scene::sceneNode *> objectsInRect(vi::common::rect const& rect);
            
            void insertObject(vi::scene::sceneNode *object);
            void updateObject(vi::scene::sceneNode *object);
            void removeObject(vi::scene::sceneNode *object);
            
            void deleteAllObjects();
            
        private:
            std::vector<vi::scene::sceneNode *> _objectsInRect(vi::common::rect const& rect);
            void _insertObject(vi::scene::sceneNode *object);
            
            vi::common::rect frame;
            uint32_t divisions;
            
            quadtree *subnodes[4]; // Clockwise order, 0 = upper left
            quadtree *parent;
            
            std::vector<vi::scene::sceneNode *>objects;
        };
    }
}
