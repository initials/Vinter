//
//  ViScene.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#include <vector>
#import <Foundation/Foundation.h>

namespace vi
{
    namespace common
    {
        class quadtree;
        class rect;
    }
    
    namespace scene
    {
        class sceneNode;
        
        class scene
        {
        public:
            scene(float minX=-1024.0, float minY=-1024.0, float maxX=1024, float maxY=1024, uint32_t subdivisions = 8);
            ~scene();
            
            void addNode(vi::scene::sceneNode *node);
            void removeNode(vi::scene::sceneNode *node);
            
            void deleteAllNodes();
            
            std::vector<vi::scene::sceneNode *>nodesInRect(vi::common::rect const& rect);
        private:
            vi::common::quadtree *quadtree;
        };
    }
}
