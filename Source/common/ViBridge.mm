//
//  ViBridge.mm
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//


#import "ViBridge.h"

namespace vi
{
    namespace common
    {
        objCBridge::objCBridge(id ttarget, SEL tselector)
        {
            target = ttarget;
            selector = tselector;
        }
    }
}


@implementation ViCppBridge
@synthesize function0, function1, function2, function3;

- (void)parameter0Action
{
    if(function0)
        function0();
}

- (void)parameter1Action:(void *)value
{
    if(function1)
    {
        function1(value);
    }
    else
    {
        [self parameter0Action];
    }
}

- (void)parameter2Action:(void *)value1 :(void *)value2
{
    if(function2)
    {
        function2(value1, value2);
    }
    else
    {
        [self parameter1Action:value1];
    }
}

- (void)parameter3Action:(void *)value1 :(void *)value2 :(void *)value3
{
    if(function3)
    {
        function3(value1, value2, value3);
    }
    else
    {
        [self parameter2Action:value1 :value2];
    }
}

@end
