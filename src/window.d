// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.window;
import g4d.gl.lib,
       g4d.math.vector,
       g4d.glfw;
import std.conv,
       std.string;

// Window is a class that manages GLFWwindow.
// Initializing GLFW will be executed automatically if it's necessary.
class Window
{
    // Whether libraries has been initialized.
    protected static bool _libInitialized;
    protected static void initLibraries ()
    {
        if ( !_libInitialized ) {
            initGLFW();
            DerelictGL3.load();
            _libInitialized = true;
        }
    }

    protected static uint _windowCount;

    // Handles events of all window.
    static void pollEvents ()
    {
        enforce!glfwPollEvents();
    }

    protected GLFWwindow* _window;

    this ( vec2i sz, string text )
    {
        initLibraries();
        _windowCount++;

        enforce!glfwWindowHint( GLFW_CONTEXT_VERSION_MAJOR, 3 );
        enforce!glfwWindowHint( GLFW_CONTEXT_VERSION_MINOR, 3 );
        enforce!glfwWindowHint( GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE );

        _window = enforce!glfwCreateWindow(
                sz.x, sz.y, text.toStringz, null, null );
        enforce!glfwMakeContextCurrent( _window );
        DerelictGL3.reload();
    }
    ~this ()
    {
        _windowCount--;
        if ( _windowCount == 0 ) {
            enforce!glfwTerminate();
        } else {
            enforce!glfwDestroyWindow( _window );
        }
        _window = null;
    }

    @property bool alive ()
    {
        return !enforce!glfwWindowShouldClose( _window );
    }

    void resetFrame ()
    {
        enforce!glfwMakeContextCurrent( _window );
        DerelictGL3.reload();
        enforce!glClear( GL_COLOR_BUFFER_BIT );
    }
    void applyFrame ()
    {
        enforce!glfwSwapBuffers( _window );
    }
}
