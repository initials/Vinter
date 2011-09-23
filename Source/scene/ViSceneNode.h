//
//  ViSceneNode.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#include <vector>
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
            /**
             * No clip flag. If set, the node won't be clipped
             **/
            sceneNodeFlagNoclip = 1
        };
        
        /**
         * @brief A scene node represents a object inside a scene
         *
         * A scene node by itself is a void object which can't be rendered because it doesn't contain a material or mesh. However, it can be subclassed
         * to allow it to render more useful stuff. Usually you create a mesh and material in a scene nodes subclass which is then rendered by the renderer.
         * All other logic is implemented inside the scene node, like updating the matrix and updating itself on position changes etc.<br />
         * <br />
         * Scene nodes can also contain childs. A child is an object that is clipped together with its parent (so update the size of the parent if needed),
         * it will also be rendered relative to its parent by the renderer. Childs can also contain childs again.
         **/
        class sceneNode
        {
            friend class vi::common::quadtree;
        public:
            /**
             * Constructor
             **/
            sceneNode(vi::common::vector2 const& pos=vi::common::vector2(), vi::common::vector2 const& tsize=vi::common::vector2(), uint32_t tlayer = 0);
            ~sceneNode();
            
            /**
             * Function invoked before the node is rendered
             * @remark The function will set the matrix of the node to represent the current position and rotation.
             **/
            virtual void visit(double timestep);

            /**
             * Sets a new position
             **/
            void setPosition(vi::common::vector2 const& point);
            /**
             * Sets a new size
             **/
            void setSize(vi::common::vector2 const& tsize);
            /**
             * Sets the flags of the node. Flags are represented as OR'ed bit field
             **/
            void setFlags(uint32_t flags);
            
            
            /**
             * Returns the position of the node
             **/
            vi::common::vector2 getPosition();
            /**
             * Returns the size of the node
             **/
            vi::common::vector2 getSize();
            /**
             * Returns the flags of the node. Flags are represented as OR'ed bit field
             **/
            uint32_t getFlags();
            
            /**
             * Returns true if the node has any childrens.
             **/
            bool hasChilds();
            /**
             * Returns a vector with all the childrens of the node
             * @remark Don't delete the vector!
             **/
            std::vector<vi::scene::sceneNode *> *getChilds();
            
            /**
             * Adds the given scene node as child
             * @remark If the node already has a parent, it will automatically removed from that parent.
             **/
            void addChild(vi::scene::sceneNode *child);
            /**
             * Removes the given child.
             **/
            void removeChild(vi::scene::sceneNode *child);
            
            
            /**
             * The rotation of the node
             **/
            GLfloat rotation;
            /**
             * The layer of the node. Nodes with a higher layer are drawn above nodes with a lower layer.
             **/
            uint32_t layer;
            
            
            /**
             * The mesh of the node. Default value is NULL
             **/
            vi::common::mesh *mesh;
            /**
             * The material of the node. Default value is NULL
             **/
            vi::graphic::material *material;
            
            /**
             * The matrix of the node
             **/
            vi::common::matrix4x4 matrix;
            /**
             * A camera which shouldn't render the node. This is useful if you want render something onto the texture of the scne node but don't want to
             * render the node also into the texture (now you are thinking with portals)
             **/
            vi::scene::camera *noPass;
            
        protected:
            vi::common::vector2 position;
            vi::common::vector2 size;
            uint32_t flags;
            
        private:
            vi::common::quadtree *tree;
            vi::scene::sceneNode *parent;
            std::vector<vi::scene::sceneNode *> childs;
        };
    }
}