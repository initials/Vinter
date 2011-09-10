//
//  ViQuaternion.cpp
//  Vinter
//
//  Copyright 2011 by Nils Daumann Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#include <cmath>
#import "ViQuaternion.h"
#import "ViVector3.h"
#import "ViVector4.h"
#import "ViMatrix4x4.h"

namespace vi
{
    namespace common
    {
        quaternion::quaternion(quaternion const& quat)
        {
            *this = quat;
        }
        
        quaternion::quaternion(float x_, float y_, float  z_, float w_)
        {
            x = x_;
            y = y_;
            z = z_;
            w = w_;
        }
        
        
        quaternion::quaternion(vector3 const& rot)
        {
            makeEuler(rot);
        }
        
        quaternion::quaternion(vector4 const& rot)
        {
            makeAxisAngle(rot);
        }
        
        
        
        bool quaternion::operator== (quaternion const& other)
        {
            return (x == other.x && y == other.y && z == other.z && w == other.w);
        }
        
        bool quaternion::operator!= (quaternion const& other)
        {
            return (x != other.x || y != other.y || z != other.z || w != other.w);
        }
        
        quaternion quaternion::operator= (quaternion const& other)
        {
            x = other.x;
            y = other.y;
            z = other.z;
            w = other.w;
            return *this;
        }
        
        quaternion quaternion::operator= (vector3 const& other)
        {
            makeEuler(other);
            return *this;
        }
        
        quaternion quaternion::operator= (vector4 const& other)
        {
            makeAxisAngle(other);
            return *this;
        }
        
        quaternion quaternion::operator+=  (quaternion const& other)
        {
            w += other.w;
            x += other.x;
            y += other.y;
            z += other.z;
            return *this;
        }
        
        quaternion quaternion::operator-=  (quaternion const& other)
        {
            w -= other.w;
            x -= other.x;
            y -= other.y;
            z -= other.z;
            return *this;
        }
        
        quaternion quaternion::operator*= (quaternion const& other)
        {
            quaternion temp(*this);
            w = -temp.x * other.x-temp.y*other.y-temp.z*other.z+temp.w*other.w;
            x =  temp.x * other.w+temp.y*other.z-temp.z*other.y+temp.w*other.x;
            y = -temp.x * other.z+temp.y*other.w+temp.z*other.x+temp.w*other.y;
            z =  temp.x * other.y-temp.y*other.x+temp.z*other.w+temp.w*other.z;
            return *this;
        }
        
        quaternion quaternion::operator/=  (quaternion const& other)
        {
            quaternion temp(*this);
            w = (temp.w*other.w + temp.x*other.x + temp.y*other.y + temp.z*other.z) / (other.w*other.w + other.x*other.x + other.y*other.y + other.z*other.z);
            x = (temp.x*other.w - temp.w*other.x - temp.z*other.y + temp.y*other.z) / (other.w*other.w +  other.x*other.x + other.y*other.y + other.z*other.z);
            y = (temp.y*other.w + temp.z*other.x - temp.w*other.y - temp.x*other.z) / (other.w*other.w +  other.x*other.x + other.y*other.y + other.z*other.z);
            z = (temp.z*other.w - temp.y*other.x + temp.x*other.y - temp.w*other.z) / (other.w*other.w +  other.x*other.x + other.y*other.y + other.z*other.z);
            return *this;
        }
        
        quaternion quaternion::operator+ (quaternion const& other)
        {
            quaternion res(*this);
            res += other;
            return res;
        }
        
        quaternion quaternion::operator- (quaternion const& other)
        {
            quaternion res(*this);
            res -= other;
            return res;
        }
        
        quaternion quaternion::operator* (quaternion const& other)
        {
            quaternion res(*this);
            res *= other;
            return res;
        }
        quaternion quaternion::operator/ (quaternion const& other)
        {
            quaternion res(*this);
            res /= other;
            return res;
        }
        
        quaternion quaternion::operator*= (vector4 const& other)
        {
            quaternion axang(other);
            *this *= axang;
            return *this;
        }
        
        quaternion quaternion::operator/= (vector4 const& other)
        {
            quaternion axang(other);
            *this /= axang;
            return *this;
        }
        
        quaternion quaternion::operator* (vector4 const& other)
        {
            quaternion res(*this);
            res *= other;
            return res;
        }
        
        quaternion quaternion::operator/ (vector4 const& other)
        {
            quaternion res(*this);
            res /= other;
            return res;
        }
        
        quaternion quaternion::operator+= (vector3 const& other)
        {
            vector3 euler = *this;
            euler += other;
            *this = euler;
            return *this;
        }
        
        quaternion quaternion::operator-= (vector3 const& other)
        {
            vector3 euler = *this;
            euler -= other;
            *this = euler;
            return *this;
        }
        
        quaternion quaternion::operator+ (vector3 const& other)
        {
            quaternion res(*this);
            res += other;
            return res;
        }
        
        quaternion quaternion::operator- (vector3 const& other)
        {
            quaternion res(*this);
            res -= other;
            return res;
        }
        
        quaternion quaternion::operator*= (float other)
        {
            x *= other;
            y *= other;
            z *= other;
            w *= other;
            return *this;
        }
        
        quaternion quaternion::operator/=  (float other)
        {
            x /= other;
            y /= other;
            z /= other;
            w /= other;
            return *this;
        }
        
        quaternion quaternion::operator* (float other)
        {
            quaternion res(*this);
            res *= other;
            return res;
        }
        
        quaternion quaternion::operator/ (float other)
        {
            quaternion res(*this);
            res /= other;
            return res;
        }
        
    
        
        void quaternion::makeIdentity()
        {
            x = 0.0f;
            y = 0.0f;
            z = 0.0f;
            w = 1.0f;
        }
        
        void quaternion::makeEuler(vector3 const& rot)
        {
            const float fSinPitch(sinf(rot.x * M_PI / 360.0f));
            const float fCosPitch(cosf(rot.x * M_PI / 360.0f));
            const float fSinYaw(sinf(rot.y * M_PI / 360.0f));
            const float fCosYaw(cosf(rot.y * M_PI / 360.0f));
            const float fSinRoll(sinf(rot.z * M_PI / 360.0f));
            const float fCosRoll(cosf(rot.z * M_PI / 360.0f));
            const float fCosPitchCosYaw(fCosPitch * fCosYaw);
            const float fSinPitchSinYaw(fSinPitch * fSinYaw);
            
            x = fSinRoll * fCosPitchCosYaw     - fCosRoll * fSinPitchSinYaw;
            y = fCosRoll * fSinPitch * fCosYaw + fSinRoll * fCosPitch * fSinYaw;
            z = fCosRoll * fCosPitch * fSinYaw - fSinRoll * fSinPitch * fCosYaw;
            w = fCosRoll * fCosPitchCosYaw     + fSinRoll * fSinPitchSinYaw;
            
            normalize();
        }
        
        void quaternion::makeEuler(vector4 const& rot)
        {
            makeEuler(vector3(rot.x, rot.y, rot.z));
        }
        
        void quaternion::makeAxisAngle(vector3 const& axis, float ang)
        {
            const float halfang = ang * M_PI / 360.0f;
            const float fsin = sin(halfang);
            w = cos(halfang);
            x = fsin*axis.x;
            y = fsin*axis.y;
            z = fsin*axis.z;
            
            normalize();
        }
        
        void quaternion::makeAxisAngle(vector4 const& axis)
        {
            makeAxisAngle(vector3(axis.x, axis.y, axis.z), axis.w);
        }
        
        void quaternion::makeLookAt(vector3 dir, vector3 up)
        {
            //Setup basis vectors describing the rotation given the input vector
            dir.normalize();
            vector3 right = up.cross(dir);    // The perpendicular vector to Up and Direction
            right.normalize();
            up = dir.cross(right);            // The actual up vector given the direction and the right vector
            up.normalize();
            
            /*	w = sqrt(fmax(0.0, 1.0+right.x+up.y+dir.z))/2.0;
             x = sqrt(fmax(0.0, 1.0+right.x-up.y-dir.z))/2.0;
             y = sqrt(fmax(0.0, 1.0-right.x+up.y-dir.z))/2.0;
             z = sqrt(fmax(0.0, 1.0-right.x-up.y+dir.z))/2.0;
             x =	copysign(x, up.z-dir.y);
             y =	copysign(y, dir.x-right.z);
             z =	copysign(z, right.y-up.x);*/
            
            // Algorithm in Ken Shoemake's article in 1987 SIGGRAPH course notes
            // article "Quaternion Calculus and Fast Animation".
            // Implementation taken from Ogre3D.
            
            float kRot[3][3];
            kRot[0][0] = right.x;
            kRot[1][0] = right.y;
            kRot[2][0] = right.z;
            kRot[0][1] = up.x;
            kRot[1][1] = up.y;
            kRot[2][1] = up.z;
            kRot[0][2] = dir.x;
            kRot[1][2] = dir.y;
            kRot[2][2] = dir.z;
            
            float fTrace = kRot[0][0]+kRot[1][1]+kRot[2][2];
            float fRoot;
            
            if(fTrace > 0.0)
            {
                // |w| > 1/2, may as well choose w > 1/2
                fRoot = sqrt(fTrace + 1.0f);  // 2w
                w = 0.5f*fRoot;
                fRoot = 0.5f/fRoot;  // 1/(4w)
                x = (kRot[2][1]-kRot[1][2])*fRoot;
                y = (kRot[0][2]-kRot[2][0])*fRoot;
                z = (kRot[1][0]-kRot[0][1])*fRoot;
            }
            else
            {
                // |w| <= 1/2
                static size_t s_iNext[3] = { 1, 2, 0 };
                size_t i = (kRot[1][1] > kRot[0][0]) ? 1 : 2;
                size_t j = s_iNext[i];
                size_t k = s_iNext[j];
                
                float *apkQuat[3] = {&x, &y, &z};
                
                fRoot = sqrt(kRot[i][i]-kRot[j][j]-kRot[k][k] + 1.0f);
                fRoot = 0.5f/fRoot;
                
                *apkQuat[i] = 0.5f*fRoot;
                *apkQuat[j] = (kRot[j][i]+kRot[i][j])*fRoot;
                *apkQuat[k] = (kRot[k][i]+kRot[i][k])*fRoot;
                
                w = (kRot[k][j]-kRot[j][k])*fRoot;
            }
            
            
            /*	float tx = up.z-dir.y;
             float ty = dir.x-right.z;
             float tz = right.y-up.x;
             sgLog("%f %f %f, %f %f %f", tx, ty, tz, x, y, z);*/
            
            normalize();
        }
        
        void quaternion::makeLerpS(quaternion const& quat1, quaternion const& quat2, float fac)
        {
            quaternion q1(quat1);
            quaternion q2(quat2);
            
            float angle = q1.dot(q2);
            if(angle < 0.0f)
            {
                q1 *= -1.0f;
                angle *= -1.0f;
            }
            
            float scale;
            float invscale;
            
            if((angle + 1.0f) > 0.05f)
            {
                if((1.0f-angle) >= 0.05f) //spherical interpolation
                {
                    const float theta = acos(angle);
                    const float invsintheta = 1.0f/sin(theta);
                    scale = sin(theta*(1.0f-fac))*invsintheta;
                    invscale = sin(theta*fac)*invsintheta;
                }
                else //linear interploation
                {
                    scale = 1.0f-fac;
                    invscale = fac;
                }
            }
            else
            {
                q2 = quaternion(-q1.y, q1.x, -q1.w, q1.z);
                scale = sin(M_PI*(0.5f-fac));
                invscale = sin(M_PI*fac);
            }
            
            *this = (q1*scale)+(q2*invscale);
        }
        
        void quaternion::makeLerpN(quaternion const& quat1, quaternion const& quat2, float fac)
        {
            quaternion q1(quat1);
            quaternion q2(quat2);
            *this = (q2*fac)+(q1*(1.0-fac));
        }
        
        void quaternion::makeLerpS(quaternion const& other, float fac)
        {
            makeLerpS(*this, other, fac);
        }
        
        void quaternion::makeLerpN(quaternion const& other, float fac)
        {
            makeLerpN(*this, other, fac);
        }
        
        quaternion quaternion::lerpS(quaternion const& other, float fac)
        {
            quaternion res(*this);
            res.makeLerpS(other, fac);
            return res;
        }
        
        quaternion quaternion::lerpN(quaternion const& other, float fac)
        {
            quaternion res(*this);
            res.makeLerpN(other, fac);
            return res;
        }
        
        void quaternion::normalize()
        {
            float len = length();
            if(len != 0)
            {
                float fac = 1/len;
                w *= fac;
                x *= fac;
                y *= fac;
                z *= fac;   
            }
        }
        
        void quaternion::conjugate()
        {
            x = -x;
            y = -y;
            z = -z;
        }
        
        float quaternion::length()
        {
            return sqrt(x*x+y*y+z*z+w*w);
        }
        
        float quaternion::dot(quaternion const& other)
        {
            return x*other.x+y*other.y+z*other.z+w*other.w;
        }
        
        vector3 quaternion::rotate(vector3 const& vec)
        {
            return getMatrix().transform(vec);
        }
        
        vector4 quaternion::rotate(vector4 const& vec)
        {
            return getMatrix().transform(vec);
        }
        
        matrix4x4 quaternion::getMatrix()
        {
            matrix4x4 res;
            
            res.matrix[0] = 1.0f - 2.0f * (y * y + z * z);
            res.matrix[4] = 2.0f * (x * y - z * w);
            res.matrix[8] = 2.0f * (x * z + y * w);
            res.matrix[1] = 2.0f * (x * y + z * w);
            res.matrix[5] = 1.0f - 2.0f * (x * x + z * z);
            res.matrix[9] = 2.0f * (y * z - x * w);
            res.matrix[2] = 2.0f * (x * z - y * w);
            res.matrix[6] = 2.0f * (y * z + x * w);
            res.matrix[10] = 1.0f - 2.0f * (x * x + y * y);
            
            return res;
        }
        
        vector3 quaternion::getEuler()
        {
            vector3 res;
            const float sqx = x*x;
            const float sqy = y*y;
            const float sqz = z*z;
            
            float clamped = 2.0f*(x*y+z*w);
            if(clamped > 0.99999f)
            {
                res.x = 2.0f*atan2(x, w)*180/M_PI;
                res.y = 90.0f;
                res.z = 0.0f;
                return res;
            }
            else if(clamped < -0.99999f)
            {
                res.x = -2.0f*atan2(x, w)*180/M_PI;
                res.y = -90.0f;
                res.z = 0.0f;
                return res;
            }
            
            res.x = (float)(atan2(2.0*(y*w-x*z), 1.0-2*(sqy+sqz)));
            res.y = asin(clamped);
            res.z = (float)(atan2(2.0*(x*w-y*z), 1.0-2*(sqx+sqz)));
            res *= 180.0f/M_PI;
            
            return res;
        }
        
        vector4 quaternion::getAxisAngle()
        {
            vector4 res;
            const float scale = sqrtf(x*x + y*y + z*z);
            if(scale == 0.0f || w > 1.0f || w < -1.0f)
            {
                res.w = 0.0f;
                res.x = 0.0f;
                res.y = 1.0f;
                res.z = 0.0f;
            }
            else
            {
                const float invscale = 1.0f/scale;
                res.w = (360/M_PI)*acos(w);
                res.x = x*invscale;
                res.y = y*invscale;
                res.z = z*invscale;
            }
            return res;
        }
    }
}
