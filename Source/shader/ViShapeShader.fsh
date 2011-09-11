//
//  ViShapeShader.fsh
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#if defined (GL_ES)
precision mediump float;
#endif

uniform sampler2D mTexture0;

void main()
{
    gl_FragColor = vec4(0.9, 0.0, 0.0, 0.5);
}
