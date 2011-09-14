##Overview
Vinter is a Mac OS X and iOS graphic engine featuring OpenGL shader based rendering. The engine is written in C++ with a few small parts written in Objective-C. It can be used in any Objective-C or C++ project targeting iOS 3.0 or Mac OS X 10.6 (maybe even down to 10.5 but we haven't tested this yet). As the current renderer only provides shader based rendering, the target system must support shaders (this requirement is probably met by every Mac that shipped with 10.5. iOS devices support OpenGL ES 2.0 since the iPhone 3GS and iPod Touch 3rd Gen. It is also supported on every iPad).

The goal of the engine is to be as easy to use as possible and although there are a lot of stuff missing and some parts are quite dirty, we think that the engine is already easy to use. To make it even better, we decided to make the code public so everyone can look onto it and suggest changes or even contribute some code. Nonetheless, it is already possible to create a simple or even more complex 2D game with Vinter and you are free to create any kind of project you want, comercially or free. Vinter is licensed under the MIT license, so the engine is as free to use as it can get.

You can find more information including the full API reference at <http://vinter2d.org/viki/> 

##Features
- Shader based rendering
- Full support for the OpenGL 3.2 Core Profile on Mac OS X 10.7 (this means GSlang 1.50 support and many more awesome stuff)
- Render to texture
- RGBA8888, RGBA4444, RGBA5551 and RGB565 texture formats
- Sprites with and without atlas maps
- Custom polygon shapes
- Quadtree based scene management
- A full range of vector classes (2D, 3D and 4D) and matrix and quaternion class

##Getting started
Starting a new project using Vinter is easy, just add the Vinter Source code which can be found in the "source" folder (surprise) to your project. Then, add the OpenGL.framework (Mac OS X) or the OpenGLES.framework and QuartzCore.framework (iOS) to the linked libraries of your project. Then you have to tell Xcode that it shouldn't try to compile the shader files by opening the project pane and moving all the .vsh and .fsh files down to the "Copy Files" build phase. (If you think this is annyoing (as we do), file a bug report @ bugreport.apple.com!)
The last step is importing "Vinter.h" which then imports all other headers. Feel free to do this in your prefix.pch file to have Vinter always in the visible scope.

Then you have to write some code, the basic setup is to create a vi::scene::scene instance which holds your scene, a vi::graphic::rendererOSX which renders your stuff (yes, even under iOS. The name is confusing, sorry!) and a vi::common::kernel which glues both together. Oh, and if you want to see something, you have to create a view in interface builder and set its class either to ViViewiOS or ViViewOSX (depending on the platform). Then create a new vi::scene::camera with your render view as first parameter so that the camera renders into the view. 
A better example (which you can actually compile and test) can be found in the "Tests" folder. It includes examples for iOS and Mac OS X (try to touch/click and draw something!)

##Stuff you might miss
There are no controls like buttons or text fields! And we won't add them. The cocoa text rendering system is one of the best text systems you can ever get. Use it and be happy about crisp and sharp texts instead of being unhappy with stupid bitmap fonts!

There are serious missing things to make Vinter a full game engine, like physics and sound. This stuff will be added sooner or later (probably later). Its easy to add this by yourself, so we decided to add these things later directly into Vinter.

The documenatation isn't complete. This is a serious issue and we are working hard to fix it, but writing documentation is hard, especially for non native speakers.

There are many more things you might come across and think "hey, this could be better" or "wow, I miss this one awesome thing". Please create an issue for these kind of things, while we try to add everything we can think off, we might miss something. It also helps us giving these things the right priority which in the end will help you (if you decide to use Vinter (which we hope (srsly, if you send us a picture of a project that uses Vinter, we will name our Babies after you (the last part is a lie, we will probably just be extremely happy!))))

##Known issues
- The default shader won't compile under OpenGL 3.2 as they are made for GSlang 1.20
