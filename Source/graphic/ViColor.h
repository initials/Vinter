//
//  ViColor.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import <Foundation/Foundation.h>

namespace vi
{
    namespace graphic
    {
        class color
        {
        public:
            color(float _r=0.0, float _g=0.0, float _b=0.0, float _a = 1.0);
            
            float r, g, b, a;
        };
    }
}
