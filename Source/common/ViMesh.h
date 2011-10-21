//
//  ViMesh.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#include <vector>
#import "ViBase.h"
#import "ViVector2.h"

namespace vi
{
    namespace common
    {
        /**
         * @brief Floating point X, Y, U, V vertex structure
         *
         * A structure capable of holding a vertex. A vertex contains X and Y axis information and U, V values.
         **/
        typedef struct vertex
        {
            float x, y;
            float u, v;
        } vertex;
        
        /**
         * @brief A class which maintains a list of vertices
         *
         * The mesh class stores a dynamic set of vertices and, if wanted, a vbo or two vbos for dynamic updating.
         **/
        class mesh
        {
        public:      
            /**
             * Constructor
             * @param tcount The desired number of vertices
             * @param indcount The desired number of indices
             **/
            mesh(uint32_t tcount=0, uint32_t indcount=0);
            /**
             * Constructor for a mesh that doesn't manage its own vertices and indices but uses the one provided to the constructor
             **/
            mesh(vertex *tvertices, uint16_t *tinidices, uint32_t tcount, uint32_t indcount);
            /**
             * Destructor
             * Automatically deletes the vertices and indices (if the mesh created them) and all vbos.
             **/
            ~mesh();
            
            /**
             * Translates the mesh by the given offset.
             **/
            void translate(vi::common::vector2 const& offset);
            
            /**
             * Adds a new vertex to te vertex list
             * @remark This method fails if the meshs vertices and indices isn't managed by the mesh.
             **/
			void addVertex(float x, float y);
            /**
             * Triangulates the mesh
             **/
			void triangulate();
            
            /**
             * Generates a new set of VBOs for the current mesh
             * @param dyn If true, the function will generate two VBOs instead of one useful if the mesh changes dynamically
             **/
            void generateVBO(bool dyn=false);
            /**
             * Updates the VBO.
             * @remark Call this whenever the mesh changed and should be rendered again via its VBO.
             **/
            void updateVBO();
            
            /**
             * The number of vertices
             **/
            uint32_t vertexCount;
            /**
             * The number of indices
             **/
            uint32_t indexCount;
            
            /**
             * Pointer to the vertex list.
             **/
            vertex *vertices;
            /**
             * Pointer to the index list.
             **/
			uint16_t *indices;
            
            
            /**
             * True if the mesh uses dynamic VBOs, otherwise false
             **/
            bool dynamic;
            /**
             * The handle to the current VBO
             **/
            GLuint vbo;
            /**
             * The handle to the current index VBO
             **/
            GLuint ivbo;
            
        private:
            bool vboToggled;
            bool ownsData;
            
            GLuint vbo0, vbo1;
            GLuint ivbo0, ivbo1;
        };
    }
}