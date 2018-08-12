// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module g4d.glfw.lib;
import std.conv,
       std.string;
public import derelict.glfw3.glfw3;

/// A template that enforces GLFW functions.
template enforce ( alias func )
    if ( __traits(identifier,func).indexOf("glfw") == 0 )
{
    auto enforce ( string file = __FILE__, size_t line = __LINE__, Args... ) ( Args args )
    {
        import g4d.exception: GLFWException;

        scope(exit)
        {
            if ( _glfwErrorMessage ) {
                auto errmes = _glfwErrorMessage.to!string;
                _glfwErrorMessage = null;
                enum FuncName = __traits(identifier,func);
                throw new GLFWException( FuncName, errmes, file, line );
            }
        }
        return func( args );
    }
}

/// A function that initializes GLFW library.
extern(C) void initGLFW ()
{
    _glfwErrorMessage = null;

    DerelictGLFW3.load();
    glfwSetErrorCallback( &glfwErrorHandler );
    enforce!glfwInit();
}

private __gshared char* _glfwErrorMessage;

private extern(C) void glfwErrorHandler ( int, const char* mes ) nothrow
{
    _glfwErrorMessage = cast(char*) mes;
}
