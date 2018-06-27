// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.shader.alpha3d;
import g4d.shader.fragment.alpha,
       g4d.shader.vertex.threedim,
       g4d.shader.base;

class Alpha3DShader : Shader
{
    mixin ThreeDimVertexShader;
    mixin AlphaFragShader;

    this ()
    {
        super();
    }
}
