//
//  ViColor.m
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#import "ViColor.h"

namespace vi
{
    namespace graphic
    {
        color::color(float _r, float _g, float _b, float _a)
        {
            r = _r;
            g = _g;
            b = _b;
            a = _a;
        }
        
        void color::lerp(color const& col1, color const& col2, float fac)
        {
            float invfac = 1.0f - fac;
            
            r = col1.r * invfac + col2.r * fac;
            g = col1.g * invfac + col2.g * fac;
            b = col1.b * invfac + col2.b * fac;
            a = col1.a * invfac + col2.a * fac;
        }
    }
}
