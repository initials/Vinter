//
//  ViSprite.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

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
         * A sprite is a rectangular object which renders a texture or a part of an texture.
         **/
        class sprite : public sceneNode
        {
        public:
            /**
             * Constructor
             * @param upsideDown true if the sprite should be rendered upside down, otherwise false
             **/
            sprite(vi::graphic::texture *texture, bool upsideDown=false);
            ~sprite();
            
            /**
             * Sets a new texture. The sprite will automatically update its atlas information according to the new texture when using this function.
             **/
            void setTexture(vi::graphic::texture *texture);
            /**
             * Sets new atlas informations. The atlas information is used to render only a part of the texture, defined by begin and size.
             **/
            void setAtlas(vi::common::vector2 const& begin, vi::common::vector2 const& size);
            
        private:            
            vi::common::vector2 atlasBegin;
            vi::common::vector2 atlasSize;
            
            bool isUpsideDown;
        };
    }
}
