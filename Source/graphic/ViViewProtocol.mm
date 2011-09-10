//
//  ViViewProtocol.mm
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViViewProtocol.h"

static id<ViViewProtocol> __ViViewProtocolActiveView = nil;

void ViViewSetActiveView(id<ViViewProtocol> view)
{
    __ViViewProtocolActiveView = view;
}

id<ViViewProtocol> ViViewGetActiveView()
{
    return __ViViewProtocolActiveView;
}
