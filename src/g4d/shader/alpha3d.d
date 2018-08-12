// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module g4d.shader.alpha3d;
import g4d.shader.fragment.alpha,
       g4d.shader.vertex.threedim,
       g4d.shader.base;

/// A shader for TextElement.
/// Red value is used as alpha value.
class Alpha3DShader : Shader
{
    mixin ThreeDimVertexShader;
    mixin AlphaFragShader;

    ///
    this ()
    {
        super();
    }
}
