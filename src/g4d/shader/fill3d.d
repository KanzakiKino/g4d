// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module g4d.shader.fill3d;
import g4d.shader.fragment.fill,
       g4d.shader.vertex.threedim,
       g4d.shader.base;

/// A shader that fills the polygon with single color.
class Fill3DShader : Shader
{
    mixin ThreeDimVertexShader;
    mixin FillFragShader;

    ///
    this ()
    {
        super();
    }
}
