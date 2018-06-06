#version 330 core

uniform sampler2D image;
uniform vec4      color;
varying vec2      v_uv;

void main ()
{
    gl_FragColor = vec4( color.rgb, texture( image, v_uv ).r*color.a );
}

