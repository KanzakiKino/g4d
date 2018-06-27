// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.gl.lib;
import g4d.exception;
import std.string;
public import derelict.opengl3.gl3;

// This is a template that enforces gl functions.
template enforce ( alias func )
    if ( __traits(identifier,func).indexOf("gl") == 0 &&
         __traits(identifier,func).indexOf("glfw") != 0 )
{
    auto enforce ( string file = __FILE__, size_t line = __LINE__, Args... ) ( Args args )
    {
        scope(exit)
        {
            auto err = glGetError();
            if ( err != GL_NO_ERROR ) {
                throw new GLException( __traits(identifier,func), err, file, line );
            }
        }
        return func( args );
    }
}
