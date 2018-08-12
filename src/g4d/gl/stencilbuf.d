// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module g4d.gl.stencilbuf;
import g4d.gl.lib;

/// A manager of the stencil buffer.
struct StencilBuffer
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
    static void clear ( int def = 0 )
    {
        enforce!glClearStencil( def );
        enforce!glClear( GL_STENCIL_BUFFER_BIT );
    }

    /// Sets a stencil func to replace pixels.
    static void startModify ( int replace = 1 )
    {
        enforce!glStencilFunc( GL_ALWAYS, replace, 1 );
        enforce!glStencilOp( GL_REPLACE, GL_REPLACE, GL_REPLACE );
    }

    /// Sets a stencil func to test if the pixel is equal to success condition.
    static void startTest ( int successCondition = 1 )
    {
        enforce!glStencilOp( GL_KEEP, GL_KEEP, GL_KEEP );
        enforce!glStencilFunc( GL_EQUAL, successCondition, 1 );
    }
}
