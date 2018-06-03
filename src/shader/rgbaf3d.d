// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.shader.rgbaf3d;
import g4d.shader.fragment.rgbaf,
       g4d.shader.vertex.perspective,
       g4d.shader.base;

class RGBAf3DShader : Shader
{
    mixin PerspectiveVertexShader;
    mixin RGBAfFragShader;

    this ()
    {
        super();
    }
}
