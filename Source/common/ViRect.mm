//
//  ViRect.mm
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViRect.h"

namespace vi
{
    namespace common
    {
        rect::rect(float x, float y, float width, float height)
        {
            origin.x = x;
            origin.y = y;
            
            size.x = width;
            size.y = height;
            
            this->validateRect();
        }
        
        rect::rect(vector2 const& org, vector2 const& sze)
        {
            origin = org;
            size = sze;
            
            this->validateRect();
        }
        
        rect::rect(vi::common::rect const& rect, float insetX, float insetY)
        {
            origin = rect.origin;
            size = rect.size;
            
            if(insetX >= kViEpsilonFloat)
            {
                float halfX = insetX * 0.5f;

                origin.x += halfX;
                size.x -= halfX;
            }
            
            if(insetY >= kViEpsilonFloat)
            {
                float halfY = insetY * 0.5f;
                
                origin.y += halfY;
                size.y -= halfY;
            }
        }
        
        
        void rect::validateRect()
        {
            if(size.x < 0.0)
            {
                origin.x -= size.x;
                size.x = -size.x;
            }
            
            if(size.y < 0.0)
            {
                origin.y -= size.y;
                size.y = -size.x;
            }
        }
  
        
        bool rect::containsPoint(vi::common::vector2 const& point)
        {
            return ((point.x >= origin.x && point.x <= origin.x + size.x) && (point.y >= origin.y && point.y <= origin.y + size.y));
        }
        
        bool rect::intersectsRect(vi::common::rect const& otherRect)
        {
            return CGRectIntersectsRect(CGRectMake(origin.x, origin.y, size.x, size.y), 
                                        CGRectMake(otherRect.origin.x, otherRect.origin.y, otherRect.size.x, otherRect.size.y));

        }
        
        bool rect::containsRect(vi::common::rect const& otherRect)
        {
            vi::common::vector2 point = vi::common::vector2(otherRect.origin);
            point += otherRect.size;
            
            return (containsPoint(otherRect.origin) && containsPoint(point));
        }
        
        

        float rect::left()
        {
            return origin.x;
        }
        
        float rect::right()
        {
            return origin.x + size.x;
        }
        
        float rect::top()
        {
            return origin.y;
        }
        
        float rect::bottom()
        {
            return origin.y + size.y;
        }
    }
}
