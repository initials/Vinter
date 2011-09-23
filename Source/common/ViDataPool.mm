//
//  ViDataPool.m
//  Vinter2D
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViDataPool.h"
#import "ViKernel.h"
#import "ViBase.h"

namespace vi
{
    namespace common
    {
        namespace dataPool
        {
            std::string pathForFile(std::string const& _file)
            {
                NSString *file = [NSString stringWithUTF8String:_file.c_str()];
                NSString *name = [file stringByDeletingPathExtension];
                NSString *exte = [file pathExtension];
                NSString *path = nil;
                
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
                NSString *device = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? @"~iphone" : @"~ipad";
                NSString *scale = @"";
                
                if(vi::common::kernel::sharedKernel() && fabs(vi::common::kernel::sharedKernel()->scaleFactor - 2.0f) <= kViEpsilonFloat)
                    scale = @"@2x";
                
                if(!path)
                    path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%@%@", name, scale, device] ofType:exte];
                
                if(!path)
                    path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%@", name, device] ofType:exte];
                
                if(!path)
                    path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%@", name, scale] ofType:exte];
#endif
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
                if(!path)
                    path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%@", name, @"~mac"] ofType:exte];
#endif
                
                if(!path)
                    path = [[NSBundle mainBundle] pathForResource:name ofType:exte];
                
                return std::string([path UTF8String]);
            }
        }
    }
}
