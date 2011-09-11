//
//  ViScene.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#include <vector>

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
        
        /**
         * @brief A scene manages scene nodes for rendering
         **/
        class scene
        {
        public:
            /**
             * Construcor
             **/
            scene(float minX=-4096, float minY=-4096, float maxX=4096, float maxY=4096, uint32_t subdivisions = 4);
            ~scene();
            
            /**
             * Adds the given scene node to the scene
             **/
            void addNode(vi::scene::sceneNode *node);
            /**
             * Removes the given scene node from the scene
             **/
            void removeNode(vi::scene::sceneNode *node);
            
            /**
             * Deletes all nodes, calling their destructors
             **/
            void deleteAllNodes();
            
            /**
             * Returns the nodes inside the given rectangle.
             **/
            std::vector<vi::scene::sceneNode *>nodesInRect(vi::common::rect const& rect);
        private:
            vi::common::quadtree *quadtree;
        };
    }
}
