//
//  ViAsset.mm
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViAsset.h"

namespace vi
{
    namespace common
    {
        asset::asset()
        {
            name = NULL;
        }
        
        asset::~asset()
        {
            if(name)
                delete name;
        }
        
        
        
        void asset::setName(const std::string *tname)
        {
            if(name)
                delete name;
            
            name = new std::string(tname->c_str());
        }
        
        std::string *asset::getName()
        {
            return name;
        }
    }
}