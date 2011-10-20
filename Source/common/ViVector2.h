//
//  ViVector2.h
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
        class vector3;
        
        /**
         * @brief 2D Vector
         **/
        class vector2
        {
        public:
            vector2(float _x = 0.0f, float _y = 0.0f);
            vector2(vector2 const& other);
            vector2(vector3 const& other);
            vector2(CGPoint point);
            
    
            inline bool operator== (vector2 const& other)
            {
                float absX = fabsf(x - other.x);
                float absY = fabsf(y - other.y);
                
                return (absX <= kViEpsilonFloat && absY <= kViEpsilonFloat);
            }
            
            inline bool operator!= (vector2 const& other)
            {
                vector2 res(*this);
                return !(res == other);
            }
            
            
            
            inline vector2 operator= (vector2 const& other)
            {
                x = other.x;
                y = other.y;
                
                return *this;
            }
            
            inline vector2 operator+= (vector2 const& other)
            {
                x += other.x;
                y += other.y;
                
                return *this;
            }
            
            inline vector2 operator+= (float other)
            {
                x += other;
                y += other;

                return *this;
            }
            
            inline vector2 operator-= (vector2 const& other)
            {
                x -= other.x;
                y -= other.y;

                return *this;
            }
            
            inline vector2 operator-= (float other)
            {
                x -= other;
                y -= other;

                return *this;
            }
            
            inline vector2 operator*= (vector2 const& other)
            {
                x *= other.x;
                y *= other.y;
                
                return *this;
            }
            
            inline vector2 operator*= (float other)
            {
                x *= other;
                y *= other;

                return *this;
            }
            
            inline vector2 operator/= (vector2 const& other)
            {
                x /= other.x;
                y /= other.y;

                return *this;
            }
            
            inline vector2 operator/= (float other)
            {
                x /= other;
                y /= other;

                return *this;
            }
            
            
            
            inline vector2 operator+ (vector2 const& other)
            {
                vector2 result(*this);
                result.x += other.x;
                result.y += other.y;
                
                return result;
            }
            
            inline vector2 operator+ (float other)
            {
                vector2 result(*this);
                result.x += other;
                result.y += other;
                
                return result;
            }
            
            inline vector2 operator- (vector2 const& other)
            {
                vector2 result(*this);
                result.x -= other.x;
                result.y -= other.y;

                return result;
            }
            
            inline vector2 operator- (float other)
            {
                vector2 result(*this);
                result.x -= other;
                result.y -= other;

                return result;
            }
            
            inline vector2 operator* (vector2 const& other)
            {
                vector2 result(*this);
                result.x *= other.x;
                result.y *= other.y;

                return result;
            }
            
            inline vector2 operator* (float other)
            {
                vector2 result(*this);
                result.x *= other;
                result.y *= other;

                return result;
            }
            
            inline vector2 operator/ (vector2 const& other)
            {
                vector2 result(*this);
                result.x /= other.x;
                result.y /= other.y;
                
                return result;
            }
            
            inline vector2 operator/ (float other)
            {
                vector2 result(*this);
                result.x /= other;
                result.y /= other;
                
                return result;
            }
            
            
            
            inline const float squaredLength()
            {
                return x * x + y * y;
            }
            
            inline const float length()
            {
                return sqrtf(squaredLength());
            }
            
            
            inline const float dot(vector2 const& other)
            {
                return x * other.x + y * other.y;
            }
            
            inline const float dot(vector3 const& other)
            {
                vector2 temp(other);
                return dot(temp);
            }
            
            inline const float dist(vector2 const& other)
            {
                vector2 temp;
                temp = *this - other;
                return temp.length();
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
            
            float x, y;
        };
    }
}
