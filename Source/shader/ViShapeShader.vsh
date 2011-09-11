//
//  ViShapeShader.vsh
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

attribute vec2 vertPos;
uniform mat4 matProjViewModel;

void main()
{
    gl_Position = matProjViewModel * vec4(vertPos, 1.0, 1.0);
}
