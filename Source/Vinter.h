//
//  Vinter.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#ifndef VINTER_H_
#define VINTER_H_

#import "ViBase.h"
#import "ViDataPool.h"

#import "ViVector2.h"
#import "ViVector3.h"
#import "ViVector4.h"
#import "ViRect.h"
#import "ViMatrix4x4.h"
#import "ViQuadtree.h"

#import "ViKernel.h"
#import "ViContext.h"
#import "ViScene.h"
#import "ViSceneNode.h"
#import "ViSprite.h"
#import "ViSpriteFactory.h"
#import "ViShape.h"

#import "ViTexture.h"
#import "ViTexturePVR.h"
#import "ViColor.h"
#import "ViMesh.h"

#import "ViEvent.h"
#import "ViResponder.h"
#import "ViBridge.h"

#import "ViRenderer.h"
#import "ViRendererOSX.h"

#import "ViViewProtocol.h"
#import "ViViewOSX.h"
#import "ViViewiOS.h"

namespace vi
{
    /**
     * Common namespace containing common used classes
     **/
    namespace common
    {
    }
    
    /**
     * Namespace which contains graphic related classes
     **/
    namespace graphic
    {
    }
    
    /**
     * Namespace containing input and event related classes
     **/
    namespace input
    {
    }
    
    /**
     * Rendering related namespace
     **/
    namespace scene
    {
    }
}

#endif


/** 
 * @mainpage Vinter2D API reference
 * <img src="http://vinter2d.org/stuff/logo.png" align="center" alt="Logo"/>
 * <div align="center"><a href="http://vinter2d.org">Project home</a></div>
 *
 * @section intro_sec Introduction
 * This is the Vinter2D API reference, it is generated based on Vinter2D 0.2.4.<br />
 * If you are new to Vinter2D, head over to the <a href="http://vinter2d.org/viki/">wiki</a> and read the tutorials or look into the example projects in the Vinter2D source directory.
 * <br /><br />
 * @subpage changelog
 * <br /><br />
 * @subpage license
 **/

/**
 * @page changelog Changelog
 * <b>Version 0.2.4</b><br />
 * Added support for childs for scene nodes. (see vi::scene::sceneNode)<br />
 * Added a sprite factory class that allows creating multiple sprites which share the same mesh<br />
 * Added caching for VBOs in the renderer<br />
 * Added some helper functions into the kernel and color class<br />
 * Changed the way quadtrees and the scene class return data (they now use a pointer instead of returning the results on the stack)<br />
 * Fixed two state bugs in the renderer which may resulted in non switched textures and blend modes.<br />
 * <br />
 * <br />
 * <b>Version 0.2.3</b><br />
 * Added support for PVR textures (both compressed and uncompressed)<br />
 * Added a function for getting pathes for files that respects naming conventions like @2x and ~ipad<br />
 * <br />
 * <br />
 * <b>Version 0.2.2</b><br />
 * Added support for RGBA 4444, RGBA 5551 and RGB 565 texture formats.<br />
 * <br />
 * <br />
 * <b>Version 0.2.1</b><br />
 * Added documentation for the vi::scene, vi::graphic and vi::input namespace<br />
 * Added a scale factor variable into texture and kernel<br />
 * Fixed retina display rendering bugs<br />
 * <br />
 * <br />
 * <b>Version 0.1</b><br />
 * Initial version.<br />
 * <br />
 * <br />
 **/

/**
 * @page license License
 * Copyright (c) 2011 by Nils Daumann and Sidney Just<br />
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated <br />
 * documentation files (the "Software"), to deal in the Software without restriction, including without limitation <br />
 * the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, <br />
 * and to permit persons to whom the Software is furnished to do so, subject to the following conditions:<br />
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.<br />
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, <br />
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR <br />
 * PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE <br />
 * FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, <br />
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.<br />
 **/

