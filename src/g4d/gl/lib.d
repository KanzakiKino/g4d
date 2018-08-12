// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module g4d.gl.lib;
import std.string;
public import derelict.opengl3.gl3;

/// A template that enforces gl functions.
template enforce ( alias func )
    if ( __traits(identifier,func).indexOf("gl") == 0 &&
         __traits(identifier,func).indexOf("glfw") != 0 )
{
    auto enforce ( string file = __FILE__, size_t line = __LINE__, Args... ) ( Args args )
    {
        import g4d.exception: GLException;

        scope(exit)
        {
            auto err = glGetError();
            if ( err != GL_NO_ERROR ) {
                enum FuncName = __traits(identifier,func);
                throw new GLException( FuncName, err, file, line );
            }
        }
        return func( args );
    }
}

extern(C) void initGL ()
{
    DerelictGL3.load();
}
