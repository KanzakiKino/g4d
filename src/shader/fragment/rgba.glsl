#version 330 core

uniform sampler2D image;
varying vec2      v_uv;

void main ()
{
    gl_FragColor = texture( image, v_uv );
}
