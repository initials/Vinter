//
//  ViCamera.mm
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViCamera.h"
#import "ViVector3.h"

namespace vi
{
    namespace scene
    {
        camera::camera(id<ViViewProtocol> tview, vi::common::vector2 const& size)
        {
            clearColor = vi::graphic::color(0.5, 0.8, 1.0, 1.0);
            view = tview;
            texture = NULL;
            
            frame.size = vi::common::vector2([view size].width, [view size].height);
            
            if(!view)
            {
                frame.size = size;
                
                glGetIntegerv(GL_FRAMEBUFFER_BINDING, &prevBuffer);
                
                glGenFramebuffers(1, &framebuffer);
                glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
                
                glGenTextures(1, &target);
                glBindTexture(GL_TEXTURE_2D, target);
                
                glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
                glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
                glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA,  size.x, size.y, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
                
                glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, target, 0);
                glBindFramebuffer(GL_FRAMEBUFFER, prevBuffer);
                
                texture = new vi::graphic::texture(target, size.x, size.y);
            }
        }
            
        camera::~camera()
        {
            if(!view)
            {
                glDeleteFramebuffers(1, &framebuffer);
                glDeleteTextures(1, &target);
                
                delete texture;
            }
        }
        
        
    
        
        vi::graphic::texture *camera::getTexture()
        {
            return texture;
        }
        
        
        void camera::bind()
        {
            if(view)
            {
                [view bind];
                frame.size = vi::common::vector2([view size].width, [view size].height);
            }
            else
            {
                glGetIntegerv(GL_FRAMEBUFFER_BINDING, &prevBuffer);		
                glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
            }
            
            projectionMatrix.makeProjectionOrtho(0.0, frame.size.x, 0.0, frame.size.y, -1.0, 1.0);
            viewMatrix.makeTranslate(vi::common::vector3(-frame.origin.x, frame.size.y + frame.origin.y, 0.0));
            
            glViewport(0, 0, (GLint)frame.size.x, (GLint)frame.size.y);
            
            glClearColor(clearColor.r, clearColor.g, clearColor.b, clearColor.a);
            glClear(GL_COLOR_BUFFER_BIT);
        }
        
        void camera::unbind()
        {
            if(view)
            {
                [view unbind];
            }
            else
            {
                glBindFramebuffer(GL_FRAMEBUFFER, prevBuffer);
            }
        }
    }
}

