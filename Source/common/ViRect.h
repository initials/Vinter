//
//  ViRect.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import <Foundation/Foundation.h>
#import "ViVector2.h"

namespace vi
{
    namespace common
    {
        /**
         * @brief A rect contains a origin and a positive width and height.
         **/
        class rect
        {
        public:
            rect(float x, float y, float width, float height);
            rect(vector2 const& org=vi::common::vector2(0.0, 0.0), vector2 const& sze=vi::common::vector2(0.0, 0.0));
            
            /**
             * Returns true if the point is inside the rect, otherwise false.
             **/
            bool containsPoint(vi::common::vector2 const& point);
            /**
             * Returns true if the rect intersects with the other rect.
             **/
            bool intersectsRect(vi::common::rect const& otherRect);
            /**
             * Returns true if the rect contains the other rect.
             **/
            bool containsRect(vi::common::rect const& otherRect);
            
            /**
             * Returns the position of the left side of the rect
             **/
            float left();            
            /**
             * Returns the position of the right side of the rect
             **/
            float right();
            /**
             * Returns the position of the top side of the rect
             **/
            float top();
            /**
             * Returns the position of the bottom side of the rect
             **/
            float bottom();
                   
            
            /**
             * The origin of the rectangle
             **/
            vi::common::vector2 origin;
            /**
             * The size of the rectangle
             **/
            vi::common::vector2 size;
            
        private:
            void validateRect();
        };
    }
}
