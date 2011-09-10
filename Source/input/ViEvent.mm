//
//  ViEvent.mm
//  Vinter
//
//  Copyright 2011 by Nils Daumann Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#include <vector>
#import "ViEvent.h"
#import "ViResponder.h"
#import "ViKernel.h"

namespace vi
{
    namespace input
    {
        event::event(vi::common::kernel *kern, uint32_t etype)
        {
            type = (vi::input::eventType)etype;
            kernel = kern;
            timestep = kernel->timestep;
            
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
            touches = nil;
#endif
            
            this->post();
        }
        
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
        std::vector<uint16_t> pressedKeys;
        event::event(NSEvent *otherEvent, uint32_t etype)
        {
            window = [otherEvent window];
            type = (vi::input::eventType)etype;
            timestamp = (double)[otherEvent timestamp];
            
            if(type & eventTypeMouse)
            {              
                buttonNumber = (uint32_t)[otherEvent buttonNumber];
                clickCount = (uint32_t)[otherEvent clickCount];
                
                CGPoint mouseLocation = [otherEvent locationInWindow];
                mouseLocation = [(NSView *)[window contentView] convertPoint:mouseLocation fromView:nil];
                
                mousePosition = vi::common::vector2(mouseLocation);

                mousePosition.y -= [(NSView *)[window contentView] frame].size.height;
                mousePosition.y = -mousePosition.y;
            }
            
            if(type & eventTypeKeyboard)
            {
                characters = std::string([[otherEvent characters] UTF8String]);
                isRepeat = [otherEvent isARepeat];
                keyCode = [otherEvent keyCode];
                
                if(type & eventTypeKeyDown)
                {
                    if(!vi::input::event::isKeyPressed(keyCode))
                    {
                        pressedKeys.push_back(keyCode);
                    }
                }
                else if(type & eventTypeKeyUp)
                {
                    std::vector<uint16_t>::iterator iterator;
                    for(iterator=pressedKeys.begin(); iterator!=pressedKeys.end(); iterator++)
                    {
                        uint16_t key = *iterator;
                        if(key == keyCode)
                        {
                            pressedKeys.erase(iterator);
                            break;
                        }
                    }
                }
            }
            
            this->post();
        }
#endif
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
        event::event(UIEvent *otherEvent, uint32_t etype, UIView *_view)
        {
            if(etype & eventTypeTouchUp)
                etype |= eventTypeMouseUp;
            
            if(etype & eventTypeTouchMoved)
                etype |= eventTypeMouseDragged;
            
            if(etype & (eventTypeTouchUp | eventTypeTouchCancelled))
                etype |= eventTypeMouseUp;
            
            window = [[UIApplication sharedApplication] keyWindow];
            view = _view;
            timestamp = [otherEvent timestamp];
            type = (vi::input::eventType)etype;
            
            touches = [[otherEvent touchesForView:view] retain];
            touchCount = (uint32_t)[touches count];
            
            this->post();
        }
        
        event::~event()
        {
            [touches release];
        }
#endif
    
        
        
        void event::post()
        {
            if(type > 0)
                vi::input::responder::postEvent(this);
        }
        
        
        bool event::isKeyPressed(uint16_t keyCode)
        {
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
            return false;
#endif

#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
            std::vector<uint16_t>::iterator iterator;
            for(iterator=pressedKeys.begin(); iterator!=pressedKeys.end(); iterator++)
            {
                uint16_t key = *iterator;
                if(key == keyCode)
                {
                    return true;
                }
            }
            
            return false;
#endif
        }
    }
}
