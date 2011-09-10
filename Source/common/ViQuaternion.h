//
//  ViQuaternion.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#ifndef VIQUATERNION_H_
#define VIQUATERNION_H_

namespace vi
{
    namespace common
    {
        class vector3;
        class vector4;
        class matrix4x4;
        
        class quaternion
        {
        public:
            quaternion(const quaternion &quat);
            quaternion(float x_ = 0.0f, float y_ = 0.0f, float z_ = 0.0f, float w_ = 1.0f);
            quaternion(const vector3 &rot);
            quaternion(const vector4 &rot);
            
            bool operator== (quaternion const& other);
            bool operator!= (quaternion const& other);
            
            quaternion operator= (quaternion const& other);
            quaternion operator= (vector3 const& other);
            quaternion operator= (vector4 const& other);
            

            quaternion operator+= (quaternion const& other);
            quaternion operator-=  (quaternion const& other);
            quaternion operator*= (quaternion const& other);
            quaternion operator/=  (quaternion const& other);
            
            quaternion operator+ (quaternion const& other);
            quaternion operator- (quaternion const& other);
            quaternion operator* (quaternion const& other);
            quaternion operator/ (quaternion const& other);
            
            quaternion operator*= (vector4 const& other);
            quaternion operator/= (vector4 const& other);
            quaternion operator* (vector4 const& other);
            quaternion operator/ (vector4 const& other);
            
            quaternion operator+= (vector3 const& other);
            quaternion operator-= (vector3 const& other);
            quaternion operator+ (vector3 const& other);
            quaternion operator- (vector3 const& other);
            
            quaternion operator*= (float other);
            quaternion operator/=  (float other);
            quaternion operator* (float other);
            quaternion operator/ (float other);

            void makeIdentity();
            
            void makeEuler(vector3 const& rot);
            void makeEuler(vector4 const& rot);

            void makeAxisAngle(vector3 const& axis, float ang);
            void makeAxisAngle(vector4 const& axis);
            
            void makeLookAt(vector3 dir, vector3 up);
            
            void makeLerpS(quaternion const& quat1, quaternion const& quat2, float fac);
            void makeLerpN(quaternion const& quat1, quaternion const& quat2, float fac);
            
            void makeLerpS(quaternion const& other, float fac);
            void makeLerpN(quaternion const& other, float fac);
            
            quaternion lerpS(quaternion const& other, float fac);
            quaternion lerpN(quaternion const& other, float fac);
            
            void normalize();
            void conjugate();
            
            float length();
            float dot(quaternion const& other);
            
            vector3 rotate(vector3 const& vec);
            vector4 rotate(vector4 const& vec);
            
 
            matrix4x4 getMatrix();
            vector3 getEuler();
            vector4 getAxisAngle();
            
            
            float x, y, z, w;
        };
    }
}

#endif
