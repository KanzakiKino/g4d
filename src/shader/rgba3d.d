// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.shader.rgba3d;
import g4d.shader.fragment.rgba,
       g4d.shader.vertex.threedim,
       g4d.shader.base;

class RGBA3DShader : Shader
{
    mixin ThreeDimVertexShader;
    mixin RGBAFragShader;

    this ()
    {
        super();
    }
}
