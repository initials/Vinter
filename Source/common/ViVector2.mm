//
//  ViVector2.m
//  Vinter
//
//  Copyright 2011 by Nils Daumann Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViVector2.h"
#import "ViVector3.h"

namespace vi
{
    namespace common
    {
        vector2::vector2(float _x, float _y)
        {
            x = _x;
            y = _y;
        }
        
        vector2::vector2(vector2 const& other)
        {
            x = other.x;
            y = other.y;
        }
        
        vector2::vector2(vector3 const& other)
        {
            x = other.x;
            y = other.y;
        }
        
        vector2::vector2(CGPoint point)
        {
            x = point.x;
            y = point.y;
        }
    }
}
