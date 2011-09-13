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

#import "ViVector2.h"
#import "ViVector3.h"
#import "ViVector4.h"
#import "ViRect.h"
#import "ViMatrix4x4.h"
#import "ViQuadtree.h"

#import "ViKernel.h"
#import "ViScene.h"
#import "ViSceneNode.h"
#import "ViSprite.h"
#import "ViShape.h"

#import "ViTexture.h"
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

#endif


/** 
 * @mainpage Vinter2D API reference
 * <img src="http://vinter2d.org/stuff/logo.png" align="center" alt="Logo"/>
 * <div align="center"><a href="http://vinter2d.org">Project home</a></div>
 *
 * @section intro_sec Introduction
 * This is the Vinter2D API reference, it is generated based on Vinter2D 0.2.1.<br />
 * If you are new to Vinter2D, head over to the <a href="http://vinter2d.org/viki/">wiki</a> and read the tutorials or look into the example projects in the Vinter2D source directory.
 * <br /><br />
 * @subpage changelog
 * <br /><br />
 * @subpage license
 **/

/**
 * @page changelog Changelog
 * <b>Version 0.2.1</b><br />
 * Added documentation for the vi::scene, vi::graphic and vi::input namespace<br />
 * Added a scale factor variable into texture and kernel (0.2.1)<br />
 * Fixed retina display rendering bugs (0.2.1)<br />
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

