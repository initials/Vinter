//
//  ViResponder.mm
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#include <vector>
#import "ViResponder.h"
#import "ViEvent.h"

namespace vi
{
    namespace input
    {
        static std::vector<vi::input::responder *> responderList;
        
        responder::responder(bool insertIntoList)
        {
            mouseDown = false;
            mouseDragged = false;
            mouseUp = false;
            
            keyDown = false;
            keyUp = false;
            
            touchDown = false;
            touchMoved = false;
            touchUp = false;
            touchCancelled = false;
            
            willDrawScene = false;
            didDrawScene = false;
            
            callback = NULL;
            inList = false;
            
            if(insertIntoList)
                this->addToResponderList();
        }
        
        responder::~responder()
        {
            this->removeFromResponderList();
        }
        
        
        
        void responder::addToResponderList()
        {
            if(!inList)
            {
                responderList.push_back(this);
                inList = true;
            }
        }
        
        void responder::removeFromResponderList()
        {
            if(inList)
            {
                std::vector<vi::input::responder *>::iterator iterator;
                for(iterator=responderList.begin(); iterator!=responderList.end(); iterator++)
                {
                    if(this == *iterator)
                    {
                        responderList.erase(iterator);
                        break;
                    }
                }
                
                inList = false;
            }
        }
        
        
        
        
        void responder::handleInputEvent(vi::input::event *event)
        {
            if(event->type & vi::input::eventTypeMouse)
            {
                if(mouseDown && event->type & vi::input::eventTypeMouseDown)
                    callback(event);
                
                if(mouseDragged && event->type & vi::input::eventTypeMouseDragged)
                    callback(event);
                
                if(mouseUp && event->type & vi::input::eventTypeMouseUp)
                    callback(event);
            }
            
            if(event->type & vi::input::eventTypeKeyboard)
            {
                if(keyDown && event->type & vi::input::eventTypeKeyDown)
                    callback(event);
                
                if(keyUp && event->type & vi::input::eventTypeKeyUp)
                    callback(event);
            }
            
            if(event->type & vi::input::eventTypeTouch)
            {
                if(touchDown && event->type & vi::input::eventTypeTouchDown)
                    callback(event);
                
                if(touchMoved && event->type & vi::input::eventTypeTouchMoved)
                    callback(event);
                
                if(touchUp && event->type & vi::input::eventTypeTouchUp)
                    callback(event);
                
                if(touchCancelled && event->type & vi::input::eventTypeTouchCancelled)
                    callback(event);
            }
        }
        
        void responder::handleRenderEvent(vi::input::event *event)
        {
            if(event->type & vi::input::eventTypeRender)
            {
                if(willDrawScene && event->type & vi::input::eventTypeRenderWillDraw)
                    callback(event);
                
                if(didDrawScene && event->type & vi::input::eventTypeRenderDidDraw)
                    callback(event);
            }
        }
        
        
        void responder::handleEvent(vi::input::event *event)
        {
            if(!callback)
                return;
            
            handleRenderEvent(event);
            handleInputEvent(event);
        }
        
        void responder::postEvent(vi::input::event *event)
        {
            std::vector<vi::input::responder *>::iterator iterator;
            for(iterator=responderList.begin(); iterator!=responderList.end(); iterator++)
            {
                vi::input::responder *responder = *iterator;
                responder->handleEvent(event);
            }
        }
    }
}
