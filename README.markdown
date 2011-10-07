##Overview
Vinter is a Mac OS X and iOS graphic engine featuring full shader based rendering. The engine is mainly written in C++ with a few small parts written in Objective-C. It can be used in any Objective-C and C++ projects targeting iOS 3.0 or Mac OS X 10.6 and later. As the renderer only provides shader based rendering, the target system must support shaders (this requirement is probably met by every Mac that shipped with 10.5. iOS devices support shaders since the iPhone 3GS and iPod Touch 3rd Gen. It is also supported on every iPad).

The goal of the engine is to be as easy to use as possible, without being too bloated like other engines. We try to keep the API as clean as possible and we are working hard to add missing stuff (see the "missing stuff" section for more info).

##Features
- Shader based rendering
- OpenGL ES 2.0 rendering, OpenGL 2.0 rendering (GSlang 1.20) and OpenGL 3.2 rendering (GSlang 1.50, only on Mac OS X 10.7)
- Render to texture
- PVR texture support (compressed and uncompressed)
- RGBA8888, RGBA4444, RGBA5551 and RGB565 texture formats
- Sprites (with and without atlas textures)
- Custom polygon shapes
- Quadtree based scene management
- A full range of vector classes (2D, 3D and 4D), a matrix and a quaternion class

##Getting started
Starting a new project using Vinter is easy, you can find a full tutorial at <http://vinter2d.org/>

##Missing stuff
There are no controls like buttons or text fields! And we won't add them. The cocoa text rendering system is one of the best text systems you can ever get. Use it and be happy about crisp and sharp texts instead of being unhappy with stupid bitmap fonts!

There are also many other things missing that prevent Vinter from being a feature complete game engine, or even graphic engine. We are working hard to add all this missing stuff, but since we have a real life too, any help is appreciated. So feel free to fork Vinter!

##Known issues
- The default shader won't compile under OpenGL 3.2 as they are made for GSlang 1.20
