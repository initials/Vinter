//
//  ViVector.cpp
//  Vinter
//
//  Copyright 2011 by Nils Daumann Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViVector4.h"
#import "ViVector3.h"
#import "ViMatrix4x4.h"

namespace vi
{
    namespace common
    {
        vector4::vector4(float _x, float _y, float _z, float _w)
        {
            x = _x;
            y = _y;
            z = _z;
            w = _w;
        }
        
        vector4::vector4(vector3 const& other)
        {
            x = other.x;
            y = other.y;
            z = other.z;
            w = 0.0f;
        }
        
        vector4::vector4(vector4 const& other)
        {
            x = other.x;
            y = other.y;
            z = other.z;
            w = other.w;
        }
       
        
        vector4 vector4::operator* (matrix4x4 const& mat)
        {
            vector4 result;
            result.x = mat.matrix[0]*x + mat.matrix[1]*x + mat.matrix[2]*x + mat.matrix[3]*x;
            result.y = mat.matrix[4]*y + mat.matrix[5]*y + mat.matrix[6]*y + mat.matrix[7]*y;
            result.z = mat.matrix[8]*z + mat.matrix[9]*z + mat.matrix[10]*z + mat.matrix[11]*z;
            result.w = mat.matrix[12]*w + mat.matrix[13]*w + mat.matrix[14]*w + mat.matrix[15]*w;
            
            return result;
        }
    }
};
