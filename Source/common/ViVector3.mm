//
//  ViVector.cpp
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViVector3.h"
#import "ViVector2.h"
#import "ViVector4.h"
#import "ViQuaternion.h"
#import "ViMatrix4x4.h"

namespace vi
{
    namespace common
    {
        vector3::vector3(float _x, float _y, float _z)
        {
            x = _x;
            y = _y;
            z = _z;
        }
        
        vector3::vector3(vector2 const& other)
        {
            x = other.x;
            y = other.y;
            z = 0.0;
        }
        
        vector3::vector3(vector3 const& other)
        {
            x = other.x;
            y = other.y;
            z = other.z;
        }
        
        vector3::vector3(vector4 const& other)
        {
            x = other.x;
            y = other.y;
            z = other.z;
        }
        
        vector3::vector3(quaternion const& quat)
        {
            *this = ((quaternion)quat).getEuler();
        }
        
        
        
        vector3 vector3::operator= (quaternion const& quat)
        {
            *this = ((quaternion)quat).getEuler();
            return *this;
        }
        
        vector3 vector3::operator* (matrix4x4 const& mat)
        {
            vector3 result;
            result.x = mat.matrix[0]*x + mat.matrix[1]*x + mat.matrix[2]*x + mat.matrix[3]*x;
            result.y = mat.matrix[4]*y + mat.matrix[5]*y + mat.matrix[6]*y + mat.matrix[7]*y;
            result.z = mat.matrix[8]*z + mat.matrix[9]*z + mat.matrix[10]*z + mat.matrix[11]*z;
            
            return result;
        }
    }
};
