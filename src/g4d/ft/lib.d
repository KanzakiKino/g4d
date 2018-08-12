// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module g4d.ft.lib;
import std.string;
public import derelict.freetype.ft;

/// A template that enforces freetype functions.
template enforce ( alias func )
    if ( __traits(identifier,func).indexOf("FT_") == 0 )
{
    void enforce ( string file = __FILE__, size_t line = __LINE__, Args... ) ( Args args )
    {
        import g4d.exception: FTException;

        auto err = func( args );
        static assert( is(typeof(err) == FT_Error),
               "Failed enforcing the functions that doesn't return error code." );
        if ( err != FT_Err_Ok ) {
            enum funcName = __traits(identifier,func);
            throw new FTException( funcName, err, file, line );
        }
    }
}
