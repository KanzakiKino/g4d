// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module g4d.gl.stencil;
import g4d.gl.lib;
import std.conv;

/// A manager of the stencil buffer.
struct Stencil
{
    ///
    this () @disable;

    /// Enables stencil test.
    static void enable ()
    {
        enforce!glEnable( GL_STENCIL_TEST );
    }
    /// Disables stencil test.
    static void disable ()
    {
        enforce!glDisable( GL_STENCIL_TEST );
    }

    /// Clears the stencil buffer.
    static void resetBuffer ( bool onlyStencil = true, bool invert = false )
    {
        auto def = invert? 1: 0;
        auto rep = invert? 0: 1;

        enable();
        enforce!glClearStencil( def );
        enforce!glClear( GL_STENCIL_BUFFER_BIT );

        enforce!glStencilFunc( GL_ALWAYS, rep, 1 );
        enforce!glStencilOp( GL_REPLACE, GL_REPLACE, GL_REPLACE );

        if ( onlyStencil ) {
            enforce!glColorMask(false,false,false,false);
            enforce!glDepthMask(false);
        }
    }
    /// Applies stencil buffer,
    /// And activates color and depth buffers.
    static void applyBuffer ()
    {
        enforce!glColorMask(true,true,true,true);
        enforce!glDepthMask(true);

        enforce!glStencilOp( GL_KEEP, GL_KEEP, GL_KEEP );
        enforce!glStencilFunc( GL_EQUAL, 1, 1 );
    }
}
