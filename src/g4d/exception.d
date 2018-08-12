// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
 +
 + This module declares exception types.
++/
module g4d.exception;
import std.format;

/// An exception type that is used in g4d.
class G4dException : Exception
{
    ///
    this ( string mes, string file = __FILE__, size_t line = __LINE__ )
    {
        super( mes, file, line );
    }
}

/// An exception type for GLFW errors.
class GLFWException : G4dException
{
    ///
    this ( string func, string mes, string file = __FILE__, size_t line = __LINE__ )
    {
        super( "%s: %s".format( func, mes), file, line );
    }
}

/// An exception type for GL errors.
class GLException : G4dException
{
    ///
    this ( string func, uint err, string file = __FILE__, size_t line = __LINE__ )
    {
        super( "%s: %d".format( func, err ), file, line );
    }
}

/// An exception type for FT errors.
class FTException : G4dException
{
    ///
    this ( string func, int err, string file = __FILE__, size_t line = __LINE__ )
    {
        super( "%s: %d".format( func, err ), file, line );
    }
}
