//
//  ViResponder.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#include <tr1/functional>
#import <Foundation/Foundation.h>

namespace vi
{
    namespace input
    {        
        class event;
        
        class responder
        {
            friend class vi::input::event;
        public:
            responder(bool insertIntoList=true);
            ~responder();
            
            std::tr1::function<void (vi::input::event *)> callback;
            
            
            // Mouse
            bool mouseDown;
            bool mouseDragged;
            bool mouseUp;
            
            // Keyboard
            bool keyDown;
            bool keyUp;
            
            // Touch
            bool touchDown;
            bool touchMoved;
            bool touchUp;
            bool touchCancelled;
            
            // Other stuff
            bool willDrawScene;
            bool didDrawScene;
            
            void addToResponderList();
            void removeFromResponderList();
        private:
            static void postEvent(vi::input::event *event);
            
            void handleEvent(vi::input::event *event);
            void handleRenderEvent(vi::input::event *event);
            void handleInputEvent(vi::input::event *event);
            
            bool inList;
        };
    }
}
