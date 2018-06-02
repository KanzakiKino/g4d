// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.shader.fill3d;
import g4d.shader.fragment.fill,
       g4d.shader.vertex.perspective,
       g4d.shader.base;

class Fill3DShader : Shader
{
    mixin PerspectiveVertexShader;
    mixin FillFragShader;

    this ()
    {
        super();
    }
}
