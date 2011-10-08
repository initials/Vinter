//
//  ViQuadtree.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#include <vector>
#import "ViRect.h"

namespace vi
{
    namespace scene
    {
        class sceneNode;
    }
    
    namespace common
    {        
        /**
         * A quadtree manages a number of scene nodes. A quadtree has a fixed size and subdivision count, so be sure to create one that really
         * fits the bounds of your scene. A scene node that is inserted out of a quadtrees bound won't be added unless the node has parent node with a
         * larger frame.
         **/
        class quadtree
        {
        public:
            /**
             * Constructor for a new root node
             * @param rect The rectangle of the root node
             * @param subdivions The number of subdivions that is allowed. Subdivisions are created only if needed.
             **/
            quadtree(vi::common::rect const& rect, uint32_t subdivions = 2);
            /**
             * Destructor, doesn't touch the objects.
             * @remark If you want to delete all objects, call deleteAllObjects() first.
             **/
            ~quadtree();
            
            /**
             * Subdivides the node, if it hasn't been subdivided yet.
             **/
            void subdivide();
            /**
             * Returns the frame of the node.
             **/ 
            vi::common::rect getFrame();
            
            /**
             * Adds the objects of the quadtree that are inside the rect to the vector.
             * @remark Before return, the vector is sorted based on the nodes layer.
             **/
            void objectsInRect(vi::common::rect const& rect, std::vector<vi::scene::sceneNode *> *vector);
            
            /**
             * Inserts the given scene node into the quadtree.
             **/
            void insertObject(vi::scene::sceneNode *object);
            /**
             * Updates the given scene node.
             * @remark Must be called whenever the bounds or position of the scene nodes changed.
             **/
            void updateObject(vi::scene::sceneNode *object);
            /**
             * Removes the scene node from the quadtree.
             **/
            void removeObject(vi::scene::sceneNode *object);
            
            /**
             * Deletes all scene nodes from the quadtree.
             **/
            void deleteAllObjects();
            
        private:
            void _objectsInRect(vi::common::rect const& rect, std::vector<vi::scene::sceneNode *> *vector);
            void _insertObject(vi::scene::sceneNode *object);
            
            vi::common::rect frame;
            uint32_t divisions;
            
            quadtree *subnodes[4]; // Clockwise order, 0 = upper left
            quadtree *parent;
            
            std::vector<vi::scene::sceneNode *>objects;
        };
    }
}
