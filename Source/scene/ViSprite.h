//
//  ViSprite.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViBase.h"
#import "ViSceneNode.h"
#import "ViTexture.h"
#import "ViRenderer.h"

namespace vi
{
    namespace scene
    {
        /**
         * @brief A simple sprite with support for atlas mapping
         *
         * A sprite is a rectangular object which renders a texture or a part of an texture into its rectangle.
         **/
        class sprite : public sceneNode
        {
        public:
            /**
             * Constructor
             * @param texture The texture for the sprite or NULL. The sprite will automatically update its size to the size of the texture.
             * @param upsideDown true if the sprite should be rendered upside down, otherwise false
             **/
            sprite(vi::graphic::texture *texture, bool upsideDown=false);
            sprite(vi::graphic::texture *texture, vi::common::mesh *sharedMesh);
            
            /**
             * Destructor. Automatically deletes the material and in case that the sprite doesn't share a mesh, it also deletes the mes.
             **/
            virtual ~sprite();
            
            
            /**
             * Sets a new texture. The sprite will automatically update its atlas information according to the new texture when using this function.
             * @param texture The new texture.
             **/
            void setTexture(vi::graphic::texture *texture);
            /**
             * Sets new atlas informations. The atlas information is used to render only a part of the texture, defined by begin and size.
             * @remark Only valid for sprites that own their mesh (eg. every sprite created via sprite(vi::graphic::texture *texture, bool upsideDown))
             **/
            void setAtlas(vi::common::vector2 const& begin, vi::common::vector2 const& size);
            
            virtual void visit(double timestep);
        private:     
            vi::common::vector2 atlasBegin;
            vi::common::vector2 atlasSize;
            
            struct
            {
                GLfloat atlasX, atlasY; // Translation
                GLfloat atlasZ, atlasW;
            };
            
            bool isUpsideDown;
            bool ownsMesh;
        };
    }
}
