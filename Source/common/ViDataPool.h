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
        class dataPool
        {
        public:
            ~dataPool();
            
            void setAsset(vi::common::asset *asset, std::string const& name);
            void removeAsset(std::string const& name, bool deleteAsset=false);
            void removeAllAssets();
            
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
