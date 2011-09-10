//
//  ViMatrix4x4.cpp
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViMatrix4x4.h"
#import "ViBase.h"
#import "ViVector3.h"
#import "ViVector4.h"
#import "ViQuaternion.h"

namespace vi
{
    namespace common
    {
        matrix4x4::matrix4x4()
        {
            makeIdentity();
        }
        
        matrix4x4::matrix4x4(matrix4x4 const& other)
        {
            memcpy(matrix, other.matrix, 16 * sizeof(float));
        }
        
        
        bool matrix4x4::operator== (matrix4x4 const& other)
        {
            for(int i=0; i<16; i++)
            {
                if(fabsf(matrix[i] - other.matrix[i]) >= kViEpsilonFloat)
                {
                    return false;
                }
            }
            
            return true;
        }
        
        bool matrix4x4::operator!= (matrix4x4 const& other)
        {
            for(int i=0; i<16; i++)
            {
                if(fabsf(matrix[i] - other.matrix[i]) >= kViEpsilonFloat)
                {
                    return true;
                }
            }
            
            return false;
        }
        
        
        
        
        matrix4x4 matrix4x4::operator= (matrix4x4 const& other)
        {
            set((float *)other.matrix);
            return *this;
        }
        
        matrix4x4 matrix4x4::operator= (float *other)
        {
            this->set(other);
            return *this;
        }
        
        matrix4x4 matrix4x4::operator* (matrix4x4 const& other)
        {
            matrix4x4 res(*this);
            res *= other;
            return res;
        }
        
        vector4 matrix4x4::operator* (vector4 const& other)
        {
            vector4 result;
            result.x = matrix[0] * other.x + matrix[4] * other.y + matrix[8] * other.z + matrix[12] * other.w;
            result.y = matrix[1] * other.x + matrix[5] * other.y + matrix[9] * other.z + matrix[13] * other.w;
            result.z = matrix[2] * other.x + matrix[6] * other.y + matrix[10] * other.z + matrix[14] * other.w;
            result.w = matrix[3] * other.x + matrix[7] * other.y + matrix[11] * other.z + matrix[15] * other.w;
            
            return result;
        }
        
        vector3 matrix4x4::operator* (vector3 const& other)
        {
            vector3 result;
            result.x = matrix[0] * other.x + matrix[4] * other.y + matrix[8] * other.z + matrix[12];
            result.y = matrix[1] * other.x + matrix[5] * other.y + matrix[9] * other.z + matrix[13];
            result.z = matrix[2] * other.x + matrix[6] * other.y + matrix[10] * other.z + matrix[14];
            
            return result;
        }
        
        
        matrix4x4 matrix4x4::operator*= (matrix4x4 const& other)
        {
            matrix4x4 temp(*this);
            
            matrix[0] = temp.matrix[0]*other.matrix[0]+temp.matrix[4]*other.matrix[1]+temp.matrix[8]*other.matrix[2]+temp.matrix[12]*other.matrix[3];
            matrix[1] = temp.matrix[1]*other.matrix[0]+temp.matrix[5]*other.matrix[1]+temp.matrix[9]*other.matrix[2]+temp.matrix[13]*other.matrix[3];
            matrix[2] = temp.matrix[2]*other.matrix[0]+temp.matrix[6]*other.matrix[1]+temp.matrix[10]*other.matrix[2]+temp.matrix[14]*other.matrix[3];
            matrix[3] = temp.matrix[3]*other.matrix[0]+temp.matrix[7]*other.matrix[1]+temp.matrix[11]*other.matrix[2]+temp.matrix[15]*other.matrix[3];
            
            matrix[4] = temp.matrix[0]*other.matrix[4]+temp.matrix[4]*other.matrix[5]+temp.matrix[8]*other.matrix[6]+temp.matrix[12]*other.matrix[7];
            matrix[5] = temp.matrix[1]*other.matrix[4]+temp.matrix[5]*other.matrix[5]+temp.matrix[9]*other.matrix[6]+temp.matrix[13]*other.matrix[7];
            matrix[6] = temp.matrix[2]*other.matrix[4]+temp.matrix[6]*other.matrix[5]+temp.matrix[10]*other.matrix[6]+temp.matrix[14]*other.matrix[7];
            matrix[7] = temp.matrix[3]*other.matrix[4]+temp.matrix[7]*other.matrix[5]+temp.matrix[11]*other.matrix[6]+temp.matrix[15]*other.matrix[7];
            
            matrix[8] = temp.matrix[0]*other.matrix[8]+temp.matrix[4]*other.matrix[9]+temp.matrix[8]*other.matrix[10]+temp.matrix[12]*other.matrix[11];
            matrix[9] = temp.matrix[1]*other.matrix[8]+temp.matrix[5]*other.matrix[9]+temp.matrix[9]*other.matrix[10]+temp.matrix[13]*other.matrix[11];
            matrix[10] = temp.matrix[2]*other.matrix[8]+temp.matrix[6]*other.matrix[9]+temp.matrix[10]*other.matrix[10]+temp.matrix[14]*other.matrix[11];
            matrix[11] = temp.matrix[3]*other.matrix[8]+temp.matrix[7]*other.matrix[9]+temp.matrix[11]*other.matrix[10]+temp.matrix[15]*other.matrix[11];
            
            matrix[12] = temp.matrix[0]*other.matrix[12]+temp.matrix[4]*other.matrix[13]+temp.matrix[8]*other.matrix[14]+temp.matrix[12]*other.matrix[15];
            matrix[13] = temp.matrix[1]*other.matrix[12]+temp.matrix[5]*other.matrix[13]+temp.matrix[9]*other.matrix[14]+temp.matrix[13]*other.matrix[15];
            matrix[14] = temp.matrix[2]*other.matrix[12]+temp.matrix[6]*other.matrix[13]+temp.matrix[10]*other.matrix[14]+temp.matrix[14]*other.matrix[15];
            matrix[15] = temp.matrix[3]*other.matrix[12]+temp.matrix[7]*other.matrix[13]+temp.matrix[11]*other.matrix[14]+temp.matrix[15]*other.matrix[15];
            
            return *this;
        }
        

        
        
        vector3 matrix4x4::transform(vector3 const& other)
        {
            vector3 result;
            result = (*this) * other;
            return result;
        }
        
        vector4 matrix4x4::transform(vector4 const& other)
        {
            vector4 result;
            result = (*this) * other;
            return result;
        }
        
        
        void matrix4x4::translate(vector3 const& trans)
        {
			matrix4x4 temp;
			temp.makeTranslate(trans);
			*this *= temp;
        }
        
        void matrix4x4::scale(vector3 const& scal)
        {
            matrix4x4 temp;
            temp.makeScale(scal);
            *this *= temp;
        }
        
        void matrix4x4::rotate(vector3 const& rot)
        {
            matrix4x4 temp;
            temp.makeRotate(rot);
            *this *= temp;
        }
        
        
        void matrix4x4::makeTranslate(vector3 const& trans)
        {
            makeIdentity();
            
            matrix[12] = trans.x;
            matrix[13] = trans.y;
            matrix[14] = trans.z;
            matrix[15] = 1.0f;
        }
        
        void matrix4x4::makeTranslate(vector4 const& trans)
        {
            makeIdentity();
            
            matrix[12] = trans.x;
            matrix[13] = trans.y;
            matrix[14] = trans.z;
            matrix[15] = trans.w;
        }
        
        void matrix4x4::makeScale(vector3 const& scal)
        {
            makeIdentity();
            
            matrix[0] = scal.x;
            matrix[5] = scal.y;
            matrix[10] = scal.z;
            matrix[15] = 1.0f;
        }
        
        void matrix4x4::makeScale(vector4 const& scal)
        {
            makeIdentity();
            
            matrix[0] = scal.x;
            matrix[5] = scal.y;
            matrix[10] = scal.z;
            matrix[15] = scal.w;
        }
        
        void matrix4x4::makeRotate(vector3 const& rot)
        {
            quaternion quat(rot);
            set(quat.getMatrix().matrix);
        }
        
        void matrix4x4::makeRotate(vector4 const& rot)
        {
            quaternion quat(rot);
            set(quat.getMatrix().matrix);
        }
        
        void matrix4x4::makeRotate(quaternion const& rot)
        {
            set(((quaternion)rot).getMatrix().matrix);
        }
        
        
        void matrix4x4::makeIdentity()
        {
            memset(matrix, 0, 16 * sizeof(float));
            
            matrix[0] = 1.0f;
            matrix[5] = 1.0f;
            matrix[10] = 1.0f;
            matrix[15] = 1.0f;
        }
		
		void matrix4x4::makeProjectionOrtho(float left, float right, float bottom, float top, float clipnear, float clipfar)
		{
			makeIdentity();
			
			float r_l = right - left;
			float t_b = top - bottom;
			float f_n = clipfar - clipnear;
			float tx = - (right + left) / (right - left);
			float ty = - (top + bottom) / (top - bottom);
			float tz = - (clipfar + clipnear) / (clipfar - clipnear);
			
			matrix[0] = 2.0f/r_l;
			matrix[5] = 2.0/t_b;
			matrix[10] = -2.0f/f_n;
			
			matrix[12] = tx;
			matrix[13] = ty;
			matrix[14] = tz;
			matrix[15] = 1.0f;
		}
    }
}