// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module g4d.gl.depthbuf;
import g4d.gl.lib;

/// A manager of the depth buffer.
struct DepthBuffer
{
    ///
    this () @disable;

    /// Enables depth test.
    static void enable ()
    {
        enforce!glEnable( GL_DEPTH_TEST );
    }
    /// Disables depth test.
    static void disable ()
    {
        enforce!glDisable( GL_DEPTH_TEST );
    }

    /// Clears the depth buffer.
    static void clear ()
    {
        enforce!glClear( GL_DEPTH_BUFFER_BIT );
    }

    /// Sets mask of the depth buffer.
    static void mask ( bool b )
    {
        enforce!glDepthMask( b );
    }
}
