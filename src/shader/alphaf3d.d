// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.shader.alphaf3d;
import g4d.shader.fragment.alphaf,
       g4d.shader.vertex.perspective,
       g4d.shader.base;

class Alphaf3DShader : Shader
{
    mixin PerspectiveVertexShader;
    mixin AlphafFragShader;

    this ()
    {
        super();
    }
}
