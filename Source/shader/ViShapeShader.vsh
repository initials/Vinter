attribute vec2 vertPos;
uniform mat4 matProjViewModel;

void main()
{
    gl_Position = matProjViewModel * vec4(vertPos, 1.0, 1.0);
}
