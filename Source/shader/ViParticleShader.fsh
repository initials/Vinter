#if defined (GL_ES)
precision mediump float;
#else
#define lowp
#define mediump
#define highp
#endif

uniform lowp sampler2D mTexture0;
uniform lowp vec4 color;
varying highp vec2 texcoord;

void main()
{
    gl_FragColor = texture2D(mTexture0, texcoord);
    gl_FragColor *= color * color.a;
}
