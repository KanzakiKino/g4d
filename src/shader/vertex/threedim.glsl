#version 330 core

uniform mat4 matrix;

attribute vec4 pos;
attribute vec2 uv;

varying vec2 v_uv;

void main ()
{
    gl_Position = matrix*pos;
    v_uv = uv;
}
