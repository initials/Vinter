//
//  ViResponder.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#include <tr1/functional>
#import <Foundation/Foundation.h>

namespace vi
{
    namespace input
    {        
        class event;
        
        /**
         * @brief Event catching class
         *
         * A responder is a class that is capable of catching posten vi::input::event instances.
         **/
        class responder
        {
            friend class vi::input::event;
        public:
            /**
             * Constructor
             * @param insertIntoList True if the responder should be added to the responder chain, otherwise false.
             **/
            responder(bool insertIntoList=true);
            /**
             * Destructor. Automatically removes the responder from the responder list.
             **/
            ~responder();
            
            /**
             * The callback that should be notified when an event is catched.
             **/
            std::tr1::function<void (vi::input::event *)> callback;
            
            
            // Mouse
            /**
             * True if the callback should be invoked on mouse down events.
             * Default: false
             **/
            bool mouseDown;
            /**
             * True if the callback should be invoked on mouse dragged events.
             * Default: false
             **/
            bool mouseDragged;
            /**
             * True if the callback should be invoked on mouse up events.
             * Default: false
             **/
            bool mouseUp;
            
            
            // Keyboard
            /**
             * True if the callback should be invoked on key down events.
             * Default: false
             **/
            bool keyDown;
            /**
             * True if the callback should be invoked on key up events.
             * Default: false
             **/
            bool keyUp;
            
            
            // Touch
            /**
             * True if the callback should be invoked on touch down events.
             * Default: false
             **/
            bool touchDown;
            /**
             * True if the callback should be invoked on touch moved events.
             * Default: false
             **/
            bool touchMoved;
            /**
             * True if the callback should be invoked on touch up events.
             * Default: false
             **/
            bool touchUp;
            /**
             * True if the callback should be invoked on touch cancelled events.
             * Default: false
             **/
            bool touchCancelled;
            
            
            // Other stuff
            /**
             * True if the callback should be invoked when a vi::common::kernel is about to draw a scene.
             * Default: false
             **/
            bool willDrawScene;
            /**
             * True if the callback should be invoked when a vi::common::kernel finished drawing a scene.
             * Default: false
             **/
            bool didDrawScene;
            
            /**
             * Adds the responder to the list. A responder can be added only once to the responder list and only added responders will catch events.
             **/
            void addToResponderList();
            /**
             * Removes the responder from the list.
             **/
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
