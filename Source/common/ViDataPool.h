//
//  ViDataPool.h
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
        namespace dataPool
        {
            /**
             * Returns the path for the given file name or an empty string
             * @remark The function takes care of specific naming conventions like ~ipad or @2x!
             **/
            std::string pathForFile(std::string const& file);
        }
    }
}
