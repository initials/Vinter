//
//  ViEvent.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#include <string>
#import <Foundation/Foundation.h>
#import "ViVector2.h"

namespace vi
{
    namespace common
    {
        class kernel;
    }
    
    namespace input
    {
        typedef enum
        {
            eventTypeMouse = 1,
            eventTypeTouch = 2,
            eventTypeKeyboard = 4,
            eventTypeRender = 8,
            
            eventTypeMouseDown = 32,
            eventTypeMouseDragged = 64,
            eventTypeMouseUp = 128,
            
            eventTypeKeyDown = 512,
            eventTypeKeyUp = 1024,
            
            eventTypeTouchDown = 2048,
            eventTypeTouchMoved = 4096,
            eventTypeTouchUp = 8192,
            eventTypeTouchCancelled = 16384,
            
            eventTypeRenderWillDraw = 32768,
            eventTypeRenderDidDraw = 65536
        } eventType;
        
        
        class event
        {
        public:
            event(vi::common::kernel *kern, uint32_t etype);
            
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
            event(NSEvent *otherEvent, uint32_t etype);
            NSWindow *window;
#endif
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
            event(UIEvent *otherEvent, uint32_t etype, UIView *view);
            ~event();
            
            UIWindow *window;
            UIView *view;
#endif
            
            eventType type;
            double timestamp;
            
            // Mouse
            uint32_t buttonNumber;
            uint32_t clickCount;
            vi::common::vector2 mousePosition;
            
            // Keyboard
            bool isRepeat;
            uint16_t keyCode;
            std::string characters;
            
            // Touch
            NSSet *touches;
            uint32_t touchCount;
            
            // Rendering
            double timestep;
            vi::common::kernel *kernel;
            
            // Misc
            static bool isKeyPressed(uint16_t keyCode);
            
        private:
            void post();
        };
    }
}
