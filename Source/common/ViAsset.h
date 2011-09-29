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
        class asset
        {
            friend class vi::common::dataPool;
        public:
            asset();
            ~asset();
            
            std::string *getName();
            
        private:
            void setName(const std::string *name);
            std::string *name;
        };
    }
}
