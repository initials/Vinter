//
//  ViKernel.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#include <string>
#include <vector>
#import "ViCamera.h"
#import "ViScene.h"
#import "ViRenderer.h"
#import "ViBridge.h"
#import "ViContext.h"

namespace vi
{
    namespace common
    {
        /**
         * @brief The root element which glues together everything to allow rendering.
         *
         * Typically you will create one instance of this class, you can then either let it render automatically (kernel::startRendering()) or force it
         * to render at custom intervals (kernel::drawScene()). A kernel also manages a stack of scenes, a scene is an object that contains entities to render
         * the top most scene is passed to the renderer associated with the kernel which will then render the scene with all cameras in the kernel.
         **/
        class kernel
        {
        public:
            /**
             * Constructor.
             * @param scene The first scene. If set, the kernel will push the scene onto the scene stack.
             * @param trenderer The renderer to use. Raises an exception if NULL.
             **/
            kernel(vi::scene::scene *scene=NULL, vi::graphic::renderer *trenderer=NULL, vi::common::context *context=NULL);
            ~kernel();
            
            /**
             * Returns the last active kernel
             * @remark Typically you only want one kernel object which then also serves as the shared kernel!
             **/
            static vi::common::kernel *sharedKernel();
            
            /**
             * Returns true if the given OpenGL extension is available.
             **/
            bool checkForExtension(std::string openglExtension);
            
            /**
             * Renders the topmost scene from all cameras using the renderer.
             * This function is automatically called if you called kernel::startRendering().
             **/
            void drawScene();
            /**
             * Renders the topmost scene automatically with a maximum FPS of maxFPS. 
             * On mobile devices you should chose a FPS which isn't the maximum possible (60 FPS) to save battery.
             **/
            void startRendering(uint32_t maxFPS);
            /**
             * Resets the timestep and lastDraw variables to 0.0. Invoke this to avoid jerkings in animation that uses timestep if there was a non normal
             * time change between two render calls (eg. if the iPhone was set to sleep mode).
             **/
            void madeSignificantTimeChange();
            /**
             * Stops the automatic rendering.
             **/
            void stopRendering();
            
            /**
             * Pushes the given scene onto the stack making it the topmost scene.
             **/
            void pushScene(vi::scene::scene *scene);
            /**
             * Pops the topmost scene from the stack.
             **/
            void popScene();
            
            /**
             * Adds the given camera to the render list.
             * @remark Only add cameras you want to get rendered as every camera requires the scene to be drawn again!
             **/
            void addCamera(vi::scene::camera *camera);
            /**
             * Removes the given camera from the render list.
             **/
            void removeCamera(vi::scene::camera *camera);
            
            
            void setContext(vi::common::context *context);
            
            /**
             * Checks if there was an OpenGL error and logs it. 
             * The function is replaced by an dummy function that does nothing in release builds to avoid expensive glGetError() calls!
             **/
            void checkError();
            
            /**
             * Returns a copy of the current scene list.
             **/
            std::vector<vi::scene::scene *> getScenes();
            /**
             * Returns a copy of the current camera list.
             **/
            std::vector<vi::scene::camera *> getCameras();
            /**
             * Returns the pointer to the used renderer.
             **/
            vi::graphic::renderer *getRenderer();
            
            vi::common::context *getContext();
            
            /**
             * The time needed to render the last frame. Can be used to make animations framerate independent by multiplying this value with it.
             **/
            double timestep;        
            /**
             * The timestamp of the last draw call in seconds with milisecond.
             **/
            double lastDraw;
            
            
            float scaleFactor;
            
        private:
            std::vector<vi::scene::scene *> *scenes;
            std::vector<vi::scene::camera *> *cameras;
            
            vi::graphic::renderer *renderer;
            vi::common::context *context;
            
            bool ownsContext;
            
            id timer;
            ViCppBridge *bridge;
        };
    }
}
