// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module g4d.element.base;
import g4d.shader.base;

/// An interface of elements.
/// Elements prepare a shader and draw something.
interface Element
{
    /// Clears all buffers.
    void clear ();

    /// Draws the element using the shader.
    void draw  ( Shader );
}
