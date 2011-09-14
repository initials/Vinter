//
//  ViDataPool.h
//  Vinter2D (iOS)
//
//  Created by Sidney Just on 14.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
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
