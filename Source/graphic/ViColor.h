//
//  ViColor.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViBase.h"

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
            /**
             * Constructor for a new color based on the given values
             * @remark The components have a max range of 0.0 to 1.0, other values will be truncated.
             **/
            color(GLfloat _r=0.0, GLfloat _g=0.0, GLfloat _b=0.0, GLfloat _a=1.0);
            /**
             * Constructor for a new color based on another color.
             **/
            color(color const& other);
            
            bool operator== (color const& other);
            bool operator!= (color const& other);
            
            color operator= (color const& other);
            
            color operator+= (color const& other);
            color operator-= (color const& other);
            color operator*= (color const& other);
            color operator/= (color const& other);
            
            color operator+ (color const& other);
            color operator- (color const& other);
            color operator* (color const& other);
            color operator/ (color const& other);
            
            /**
             * Interpolates between the color 1 and color 2.
             **/
            void lerp(color const& col1, color const& col2, float factor);
            /**
             * Converts the color to an grayscale representation.
             **/
            void grayscale();
            
            struct
            {
                /**
                 * The red component
                 **/
                GLfloat r;
                /**
                 * The green component
                 **/
                GLfloat g;
                /**
                 * The blue component
                 **/
                GLfloat b;
                /**
                 * The alpha component
                 **/
                GLfloat a;
            };
            
        private:
            void validateColor();
        };
    }
}
