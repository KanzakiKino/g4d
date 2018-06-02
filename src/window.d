// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.window;
import g4d.math.vector,
       g4d.gl,
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

    this ( Size sz, string text )
    {
        initLibraries();
        _windowCount++;

        _window = enforce!glfwCreateWindow(
                sz.x.to!int, sz.y.to!int, text.toStringz, null, null );
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

    // Clears display and makes current.
    void clearDisplay ()
    {
        enforce!glfwMakeContextCurrent( _window );
        enforce!glClear( GL_COLOR_BUFFER_BIT );
    }
    void applyDisplay ()
    {
        enforce!glfwSwapBuffers( _window );
    }
}
