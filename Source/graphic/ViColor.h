//
//  ViColor.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

namespace vi
{
    namespace graphic
    {
        /**
         * @brief RGBA color class
         *
         * The color class represents color as RGBA floating point values.
         **/
        class color
        {
        public:
            color(float _r=0.0, float _g=0.0, float _b=0.0, float _a = 1.0);

            float r/**The red component**/, g/**The green component**/, b/**The blue component**/, a/**The alpha component**/;
        };
    }
}
