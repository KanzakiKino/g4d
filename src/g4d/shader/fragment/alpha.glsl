#version 330 core

uniform sampler2D image;
uniform vec4      color;
varying vec2      v_uv;

void main ()
{
    float alpha = texture( image, v_uv ).r;

    if ( alpha == 0 ) {
        discard;
    }
    gl_FragColor = vec4( color.rgb, alpha*color.a );
}

