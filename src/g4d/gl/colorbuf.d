// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module g4d.gl.colorbuf;
import g4d.gl.lib;

/// A manager of the color buffer.
struct ColorBuffer
{
    ///
    this () @disable;

    /// Clears the color buffer.
    static void clear ()
    {
        enforce!glClear( GL_COLOR_BUFFER_BIT );
    }

    /// Sets mask of the color buffer.
    static void mask ( bool r, bool g, bool b, bool a )
    {
        enforce!glColorMask( r, g, b, a );
    }
}
