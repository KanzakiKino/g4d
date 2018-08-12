// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.glfw.window;
import g4d.gl.lib,
       g4d.glfw.cursor,
       g4d.glfw.handler,
       g4d.glfw.lib;
import gl3n.linalg;
import std.conv,
       std.string;

enum WindowHint
{
    None      = 0x0000,
    Resizable = 0b0001,
    Maximized = 0b0010,
    Floating  = 0b0100,
    Visible   = 0b1000,
}

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

            Cursor.createStandardCursors();
        }
    }

    protected static uint _windowCount;

    // Handles events of all window.
    static void pollEvents ()
    {
        enforce!glfwPollEvents();
    }

    protected GLFWwindow* _window;

    EventHandler handler;

    this ( vec2i sz, string text, int hint = WindowHint.None )
    {
        initLibraries();
        _windowCount++;

        enforce!glfwWindowHint( GLFW_RESIZABLE, hint & WindowHint.Resizable );
        enforce!glfwWindowHint(   GLFW_VISIBLE, hint & WindowHint.Visible   );
        enforce!glfwWindowHint(  GLFW_FLOATING, hint & WindowHint.Floating  );
        enforce!glfwWindowHint( GLFW_MAXIMIZED, hint & WindowHint.Maximized );

        enforce!glfwWindowHint( GLFW_CONTEXT_VERSION_MAJOR, 3 );
        enforce!glfwWindowHint( GLFW_CONTEXT_VERSION_MINOR, 3 );
        enforce!glfwWindowHint( GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE );

        _window = enforce!glfwCreateWindow(
                sz.x, sz.y, text.toStringz, null, null );
        handler = EventHandler( _window );

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
        if ( handler.throwedException ) {
            throw handler.throwedException;
        }
        enforce!glfwMakeContextCurrent( _window );
        DerelictGL3.reload();

        auto size = size;
        enforce!glViewport( 0,0, size.x, size.y );
        enforce!glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    }
    void applyFrame ()
    {
        enforce!glfwSwapBuffers( _window );
    }

    @property void title ( string text )
    {
        enforce!glfwSetWindowTitle( _window, text.toStringz );
    }

    @property vec2i pos ()
    {
        int x, y;
        enforce!glfwGetWindowPos( _window, &x, &y );
        return vec2i(x,y);
    }
    @property void pos ( vec2i p )
    {
        enforce!glfwSetWindowPos( _window, p.x, p.y );
    }

    @property vec2i size ()
    {
        int w, h;
        enforce!glfwGetWindowSize( _window, &w, &h );
        return vec2i(w,h);
    }
    @property void size ( vec2i sz )
    {
        enforce!glfwSetWindowSize( _window, sz.x, sz.y );
    }
    @property void aspectRatio ( vec2i ratio )
    {
        enforce!glfwSetWindowAspectRatio( _window, ratio.x, ratio.y );
    }
    void setClampSize ( vec2i min, vec2i max )
    {
        enforce!glfwSetWindowSizeLimits( _window, min.x, min.y, max.x, max.y );
    }

    void show ()
    {
        enforce!glfwShowWindow( _window );
    }
    void hide ()
    {
        enforce!glfwHideWindow( _window );
    }
    void focus ()
    {
        enforce!glfwFocusWindow( _window );
    }
    void close ()
    {
        enforce!glfwSetWindowShouldClose( _window, true );
    }

    void minimize ()
    {
        enforce!glfwIconifyWindow( _window );
    }
    void maximize ()
    {
        enforce!glfwMaximizeWindow( _window );
    }
    void restore ()
    {
        enforce!glfwRestoreWindow( _window );
    }

    void setCursor ( Cursor c )
    {
        enforce!glfwSetCursor( _window, c.ptr );
    }
}
