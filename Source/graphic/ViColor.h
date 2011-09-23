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
            
            /**
             * Interpolates between the color 1 and color 2.
             **/
            void lerp(color const& col1, color const& col2, float factor);
            
            struct
            {
                float r/**The red component**/;
                float g/**The green component**/;
                float b/**The blue component**/;
                float a/**The alpha component**/;
            };
        };
    }
}
