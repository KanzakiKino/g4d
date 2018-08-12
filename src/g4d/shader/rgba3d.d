// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module g4d.shader.rgba3d;
import g4d.shader.fragment.rgba,
       g4d.shader.vertex.threedim,
       g4d.shader.base;

/// A shader that supports RGBA texture.
class RGBA3DShader : Shader
{
    mixin ThreeDimVertexShader;
    mixin RGBAFragShader;

    ///
    this ()
    {
        super();
    }
}
