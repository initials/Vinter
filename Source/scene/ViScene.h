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
    
    namespace graphic
    {
        class renderer;
    }
    
    namespace scene
    {
        class sceneNode;
        class camera;
        
        /**
         * @brief A scene manages scene nodes for rendering
         **/
        class scene
        {
        public:
            /**
             * Construcor for a scene. The minX, minY, maxX and maxY values are used to generate quadtree of this size for scene management.
             * The subdivisions is the number of subdivisions the quadtree is allowed make to partitionate the level,
             * this means for a 8192x8192 quadtree with 4 subdivions that the smalles patch is 2048x2048. You should try to not get smaller than roughly
             * one screen of the device you are targeting.
             **/
            scene(vi::scene::camera *camera=NULL, float minX=-4096, float minY=-4096, float maxX=4096, float maxY=4096, uint32_t subdivisions = 4);
            /**
             * Destructor, automatically destroy the quadtree with it, but keeps the objects in it alive.
             * If you want to delete the objects inside the scene along with the scene, call deleteAllNodes() first.
             **/
            ~scene();
            
            /**
             * Adds the given camera to the render list.
             * @remark Only add cameras you want to get rendered as every camera requires the scene to be drawn again!
             **/
            void addCamera(vi::scene::camera *camera);
            /**
             * Removes the given camera from the render list.
             **/
            void removeCamera(vi::scene::camera *camera);
            /**
             * Returns a copy of the current camera list.
             **/
            std::vector<vi::scene::camera *> getCameras();
            
            
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
            std::vector<vi::scene::sceneNode *> *nodesInRect(vi::common::rect const& rect);
        
            
            void draw(vi::graphic::renderer *renderer, double timestep);
            
        private:
            std::vector<vi::scene::camera *> *cameras;
            std::vector<vi::scene::sceneNode *>nodes;
            vi::common::quadtree *quadtree;
        };
    }
}
