// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.exception;
import std.format;

// An exception type that is used in g4d.
class G4dException : Exception
{
    this ( string mes, string file = __FILE__, size_t line = __LINE__ )
    {
        super( mes, file, line );
    }
}

// An exception type for GLFW errors.
class GLFWException : G4dException
{
    this ( string func, string mes, string file = __FILE__, size_t line = __LINE__ )
    {
        super( "%s: %s".format( func, mes, file, line ) );
    }
}