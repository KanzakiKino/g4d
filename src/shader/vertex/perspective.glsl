#version 330 core

attribute vec4 pos;
attribute vec2 uv;

varying vec2 v_uv;

void main ()
{
    gl_Position = pos;
    v_uv = uv;
}
