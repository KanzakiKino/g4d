// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.glfw.lib;
import g4d.exception;
import std.conv,
       std.string;
public import derelict.glfw3.glfw3;

// This is a template that enforces GLFW functions.
template enforce ( alias func )
    if ( __traits(identifier,func).indexOf("glfw") == 0 )
{
    auto enforce ( string file = __FILE__, size_t line = __LINE__, Args... ) ( Args args )
    {
        scope(exit)
        {
            if ( _glfwErrorMessage ) {
                auto errmes = _glfwErrorMessage.to!string;
                _glfwErrorMessage = null;
                throw new GLFWException( __traits(identifier,func), errmes, file, line );
            }
        }
        return func( args );
    }
}

// This is a function that initializes GLFW library.
extern(C) void initGLFW ()
{
    _glfwErrorMessage = null;

    DerelictGLFW3.load();
    glfwSetErrorCallback( &glfwErrorHandler );
    enforce!glfwInit();
}

// GLFW error message.
private __gshared char* _glfwErrorMessage;

// GLFW error handler.
private extern(C) void glfwErrorHandler ( int, const char* mes ) nothrow
{
    _glfwErrorMessage = cast(char*) mes;
}
