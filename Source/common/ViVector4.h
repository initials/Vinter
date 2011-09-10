//
//  ViVector.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#ifndef VIVECTOR4_H_
#define VIVECTOR4_H_

#include <cmath>
#import "ViBase.h"

namespace vi
{
    namespace common
    {
        class vector3;
        class quaternion;
        class matrix4x4;
        
        /**
         * @brief 4D Vector
         **/
        class vector4
        {
        public:
            vector4(float _x = 0.0f, float _y = 0.0f, float _z = 0.0f, float _w = 0.0f);
            vector4(vector3 const& other);
            vector4(vector4 const& other);
            
            
            inline bool operator== (vector4 const& other)
            {
                float absX = fabsf(x - other.x);
                float absY = fabsf(y - other.y);
                float absZ = fabsf(z - other.z);
                float absW = fabsf(w - other.w);
                
                return (absX <= kViEpsilonFloat && absY <= kViEpsilonFloat && absZ <= kViEpsilonFloat && absW <= kViEpsilonFloat);
            }
            
            inline bool operator!= (vector4 const& other)
            {
                return !(*this == other);
            }
            
            
            vector4 operator* (matrix4x4 const& mat);
            
            inline vector4 operator= (vector4 const& other)
            {
                x = other.x;
                y = other.y;
                z = other.z;
                w = other.w;
                
                return *this;
            }
            
            inline vector4 operator= (float other)
            {
                x = other;
                y = other;
                z = other;
                w = other;
                
                return *this;
            }
            
            inline vector4 operator+= (vector4 const& other)
            {
                x += other.x;
                y += other.y;
                z += other.z;
                w += other.w;
                
                return *this;
            }
            
            inline vector4 operator+= (float other)
            {
                x += other;
                y += other;
                z += other;
                w += other;
                
                return *this;
            }
            
            inline vector4 operator-= (vector4 const& other)
            {
                x -= other.x;
                y -= other.y;
                z -= other.z;
                w -= other.w;
                
                return *this;
            }
            
            inline vector4 operator-= (float other)
            {
                x -= other;
                y -= other;
                z -= other;
                w -= other;
                
                return *this;
            }
            
            inline vector4 operator*= (vector4 const& other)
            {
                x *= other.x;
                y *= other.y;
                z *= other.z;
                w *= other.w;
                
                return *this;
            }
            
            inline vector4 operator*= (float other)
            {
                x *= other;
                y *= other;
                z *= other;
                w *= other;
                
                return *this;
            }
            
            inline vector4 operator/= (vector4 const& other)
            {
                x /= other.x;
                y /= other.y;
                z /= other.z;
                w /= other.w;
                
                return *this;
            }
            
            inline vector4 operator/= (float other)
            {
                x /= other;
                y /= other;
                z /= other;
                w /= other;
                
                return *this;
            }
            
            
            
            inline vector4 operator+ (vector4 const& other)
            {
                vector4 result(*this);
                result.x += other.x;
                result.y += other.y;
                result.z += other.z;
                result.w += other.w;
                
                return result;
            }
            
            inline vector4 operator+ (float other)
            {
                vector4 result(*this);
                result.x += other;
                result.y += other;
                result.z += other;
                result.w += other;
                
                return result;
            }
            
            inline vector4 operator- (vector4 const& other)
            {
                vector4 result(*this);
                result.x -= other.x;
                result.y -= other.y;
                result.z -= other.z;
                result.w -= other.w;
                
                return result;
            }
            
            inline vector4 operator- (float other)
            {
                vector4 result(*this);
                result.x -= other;
                result.y -= other;
                result.z -= other;
                result.w -= other;
                
                return result;
            }
            
            inline vector4 operator* (vector4 const& other)
            {
                vector4 result(*this);
                result.x *= other.x;
                result.y *= other.y;
                result.z *= other.z;
                result.w *= other.w;
                
                return result;
            }
            
            inline vector4 operator* (float other)
            {
                vector4 result(*this);
                result.x *= other;
                result.y *= other;
                result.z *= other;
                result.w *= other;
                
                return result;
            }
            
            inline vector4 operator/ (vector4 const& other)
            {
                vector4 result(*this);
                result.x /= other.x;
                result.y /= other.y;
                result.z /= other.z;
                result.w /= other.w;
                
                return result;
            }
            
            inline vector4 operator/ (float other)
            {
                vector4 result(*this);
                result.x /= other;
                result.y /= other;
                result.z /= other;
                result.w /= other;
                
                return result;
            }
            
            
            
            inline float squaredLength()
            {
                return x * x + y * y + z * z + w * w;
            }
            
            inline float length()
            {
                return sqrtf(squaredLength());
            }
            
            inline float dot(vector4 &other)
            {
                return x * other.x + y * other.y + z * other.z + w * other.w;
            }
            
            inline float dot(vector3 &other)
            {
                vector4 temp(other);
                return dot(temp);
            }
            
            inline float dist(vector4 &other)
            {
                vector4 temp;
                temp = *this - other;
                return temp.length();
            }
            
            inline vector4 cross(vector4 &other)
            {
                vector4 result;
                result.x = y * other.z - z * other.y;
                result.y = z * other.x - x * other.z;
                result.z = x * other.y - y * other.x;
                result.w = 0.0f;
                
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
            
            
            float x, y, z, w;
        };
    }
}

#endif
