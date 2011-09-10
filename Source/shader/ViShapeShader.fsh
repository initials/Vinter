#if defined (GL_ES)
precision mediump float;
#endif

uniform sampler2D mTexture0;

void main()
{
    gl_FragColor = vec4(0.9, 0.0, 0.0, 0.5);
}
