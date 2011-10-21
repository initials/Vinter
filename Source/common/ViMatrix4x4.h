//
//  ViMatrix4x4.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#include <cmath>
#include <cstring>
#import "ViBase.h"

namespace vi
{
    namespace common
    {
        class vector3;
        
        /**
         * @brief A 4x4 matrix in the format used by OpenGL (ES)
         **/
        class matrix4x4
        {
        public:
            /**
             * Creates a new identy matrix
             **/
            matrix4x4();
            /**
             * Creates a new matrix based on another matrix
             **/
            matrix4x4(matrix4x4 const& other);
            
            bool operator== (matrix4x4 const& other);
            bool operator!= (matrix4x4 const& other);
            
            matrix4x4 operator= (matrix4x4 const&  other);
            matrix4x4 operator= (float *other);
            
            matrix4x4 operator* (matrix4x4 const& other);
            matrix4x4 operator*= (matrix4x4 const& other);
            
            /**
             * Translates the matrix by the given vector.
             **/
            void translate(vector3 const& trans);
            /**
             * Scales the matrix by the given vector.
             **/
            void scale(vector3 const& scal);
            /**
             * Rotates the matrix by the given vector.
             **/
            void rotate(vector3 const& rot);

            
            /**
             * Resets the matrix to the identy matrix and then translate it by the vector.
             **/
            void makeTranslate(vector3 const& trans);
            
            /**
             * Resets the matrix to the identy matrix and then scales it by the vector.
             **/
            void makeScale(vector3 const& scal);
            
            /**
             * Resets the matrix and then rotates it by the given vector.
             **/
            void makeRotation(vector3 const& rot);

            /**
             * Resets the matrix to the identy matrix.
             **/
            void makeIdentity();
            /**
             * Sets the matrix to an orthogonal projection matrix.
             **/
			void makeProjectionOrtho(float left, float right, float bottom, float top, float clipnear, float clipfar);
            
            
            /**
             * sets the matrix to the given value
             * @param mat A pointer to a memory area with at least 16 floats!
             **/
            inline void set(float *mat)
            {
                memcpy(matrix, mat, 16 * sizeof(float));
            }
            
            /**
             * The matrix data
             **/
            float matrix[16];
        };
    }
}
