//
//  ViDataPool.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#include <string>
#include <map>
#import "ViAsset.h"

namespace vi
{
    namespace common
    {
        /**
         * @brief A data pool manages a list of assets
         *
         * A data pool saves assets using a key/value store where every asset gets a unique name used as key.
         * The data pool can also purge all assets from memory to make cleaning up data easier.
         **/
        class dataPool
        {
        public:
            /**
             * Inserts the given asset into the pool and set its name to the given name
             * @param If there was a previous asset with this name, it will be overwritten by the new asset.
             **/
            void setAsset(vi::common::asset *asset, std::string const& name);
            /**
             * Removes the given asset from the list.
             * @param deleteAsset If true, the asset will be deleted, otherwise it will just be removes from the list.
             **/
            void removeAsset(std::string const& name, bool deleteAsset=false);
            /**
             * Removes all assets from the list.
             * @param deleteAssets If true, all assets will be send a delete method.
             **/
            void removeAllAssets(bool deleteAssets=true);
            
            /**
             * Returns the asset with the given name, or NULL.
             **/
            vi::common::asset *assetForName(std::string const& name);
            
            
            
            /**
             * Returns the path for the given file name or an empty string
             * @remark The function takes care of specific naming conventions like ~ipad or @2x!
             **/
            static std::string pathForFile(std::string const& file);
        private:
            std::map<std::string, vi::common::asset *> assets;
        };
    }
}
