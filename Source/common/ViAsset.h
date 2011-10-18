//
//  ViAsset.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#include <string>

namespace vi
{
    namespace common
    {
        class dataPool;
        
        /**
         * @brief Base class for other classes that represent assets.
         *
         * A asset builds the base class for other assets such as textures and shaders. It can be added to an vi::common::dataPool and thus can be
         * easily purged from memory if no longer needed.
         **/
        class asset
        {
            friend class vi::common::dataPool;
        public:
            /**
             * Constructor for an empty asset.
             * @remark The name of the asset will be NULL!
             **/
            asset();
            /**
             * Destructor.
             **/
            virtual ~asset();
            
            
            /**
             * Returns the name of the asset or NULL if the asset has no name.
             * @remark The asset gets its name from an dataPool.
             **/
            std::string *getName();
            
        private:
            void setName(const std::string *name);
            std::string *name;
        };
    }
}
