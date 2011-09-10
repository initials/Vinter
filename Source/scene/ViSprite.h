//
//  ViSprite.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import <Foundation/Foundation.h>
#import "ViSceneNode.h"
#import "ViTexture.h"
#import "ViRenderer.h"

namespace vi
{
    namespace scene
    {
        class sprite : public sceneNode
        {
        public:
            sprite(vi::graphic::texture *texture, bool upsideDown=false);
            ~sprite();
            
            void setTexture(vi::graphic::texture *texture);
            void setAtlas(vi::common::vector2 const& begin, vi::common::vector2 const& size);
            
        private:            
            vi::common::vector2 atlasBegin;
            vi::common::vector2 atlasSize;
            
            bool isUpsideDown;
        };
    }
}
