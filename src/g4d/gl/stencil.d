// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.gl.stencil;
import g4d.gl.lib;
import std.conv;

struct Stencil
{
    this () @disable;

    static void enable ()
    {
        enforce!glEnable( GL_STENCIL_TEST );
    }
    static void disable ()
    {
        enforce!glDisable( GL_STENCIL_TEST );
    }

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
    static void applyBuffer ()
    {
        enforce!glColorMask(true,true,true,true);
        enforce!glDepthMask(true);

        enforce!glStencilOp( GL_KEEP, GL_KEEP, GL_KEEP );
        enforce!glStencilFunc( GL_EQUAL, 1, 1 );
    }
}
