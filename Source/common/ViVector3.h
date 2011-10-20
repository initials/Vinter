//
//  ViVector.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#include <cmath>
#import "ViBase.h"

namespace vi
{
    namespace common
    {
        class vector2;
        class matrix4x4;
        
        /**
         * @brief 3D Vector
         **/
        class vector3
        {
        public:
            vector3(float _x = 0.0f, float _y = 0.0f, float _z = 0.0f);
            vector3(vector2 const& other);
            vector3(vector3 const& other);
            
            
            inline bool operator== (vector3 const& other)
            {
                float absX = fabsf(x - other.x);
                float absY = fabsf(y - other.y);
                float absZ = fabsf(z - other.z);
                
                return (absX <= kViEpsilonFloat && absY <= kViEpsilonFloat && absZ <= kViEpsilonFloat);
            }
            
            inline bool operator!= (vector3 const& other)
            {
                return !(*this == other);
            }
            
            inline vector3 operator= (vector3 const& other)
            {
                x = other.x;
                y = other.y;
                z = other.z;
                
                return *this;
            }

            inline vector3 operator= (float other)
            {
                x = other;
                y = other;
                z = other;
                
                return *this;
            }
            
            inline vector3 operator+= (vector3 const& other)
            {
                x += other.x;
                y += other.y;
                z += other.z;
                
                return *this;
            }
            
            inline vector3 operator+= (float other)
            {
                x += other;
                y += other;
                z += other;
                
                return *this;
            }
            
            inline vector3 operator-= (vector3 const& other)
            {
                x -= other.x;
                y -= other.y;
                z -= other.z;
                
                return *this;
            }
            
            inline vector3 operator-= (float other)
            {
                x -= other;
                y -= other;
                z -= other;
                
                return *this;
            }
            
            inline vector3 operator*= (vector3 const& other)
            {
                x *= other.x;
                y *= other.y;
                z *= other.z;
                
                return *this;
            }
            
            inline vector3 operator*= (float other)
            {
                x *= other;
                y *= other;
                z *= other;
                
                return *this;
            }
            
            inline vector3 operator/= (vector3 const& other)
            {
                x /= other.x;
                y /= other.y;
                z /= other.z;
                
                return *this;
            }
            
            inline vector3 operator/= (float const& other)
            {
                x /= other;
                y /= other;
                z /= other;
                
                return *this;
            }
            
            
            
            inline vector3 operator+ (vector3 const& other)
            {
                vector3 result(*this);
                result.x += other.x;
                result.y += other.y;
                result.z += other.z;
                
                return result;
            }
            
            inline vector3 operator+ (float other)
            {
                vector3 result(*this);
                result.x += other;
                result.y += other;
                result.z += other;
                
                return result;
            }
            
            inline vector3 operator- (vector3 const& other)
            {
                vector3 result(*this);
                result.x -= other.x;
                result.y -= other.y;
                result.z -= other.z;
                
                return result;
            }
            
            inline vector3 operator- (float other)
            {
                vector3 result(*this);
                result.x -= other;
                result.y -= other;
                result.z -= other;
                
                return result;
            }
            
            vector3 operator* (matrix4x4 const& mat);
            inline vector3 operator* (vector3 const& other)
            {
                vector3 result(*this);
                result.x *= other.x;
                result.y *= other.y;
                result.z *= other.z;
                
                return result;
            }
            
            inline vector3 operator* (float other)
            {
                vector3 result(*this);
                result.x *= other;
                result.y *= other;
                result.z *= other;
                
                return result;
            }
            
            inline vector3 operator/ (vector3 const& other)
            {
                vector3 result(*this);
                result.x /= other.x;
                result.y /= other.y;
                result.z /= other.z;
                
                return result;
            }
            
            inline vector3 operator/ (float other)
            {
                vector3 result(*this);
                result.x /= other;
                result.y /= other;
                result.z /= other;
                
                return result;
            }
            
            
            
            inline const float squaredLength()
            {
                return x * x + y * y + z * z;
            }
            
            inline const float length()
            {
                return sqrtf(squaredLength());
            }
            
            inline const float dot(vector3 const& other)
            {
                return x * other.x + y * other.y + z * other.z;
            }
            
            inline const float dist(vector3 const& other)
            {
                vector3 temp;
                temp = *this - other;
                return temp.length();
            }
            
            inline const vector3 cross(vector3 const& other)
            {
                vector3 result;
                result.x = y * other.z - z * other.y;
                result.y = z * other.x - x * other.z;
                result.z = x * other.y - y * other.x;
                
                return result;
            }
            
            inline void makeIdentity()
            {
                *this = 0.0f;
            }
            
            inline void normalize()
            {
                float len = length();
                if(len != 0.0f)
                {
                    float fac = 1.0f / len;
                    *this *= fac;
                }
            }
            
            
            
            float x, y, z;
        };
    }
}
