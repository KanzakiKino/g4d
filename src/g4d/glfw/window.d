// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module g4d.glfw.window;
import g4d.gl.lib,
       g4d.glfw.cursor,
       g4d.glfw.handler,
       g4d.glfw.lib;
import gl3n.linalg;
import std.conv,
       std.string;

/// Hints of Window.
enum WindowHint
{
    None        = 0b0000000,
    Resizable   = 0b0000001,
    Visible     = 0b0000010,
    Decorated   = 0b0000100,
    Focused     = 0b0001000,
    AutoIconify = 0b0010000,
    Floating    = 0b0100000,
    Maximized   = 0b1000000,
}

/// A class of GLFWwindow.
/// Initializing GLFW will be executed automatically if it's necessary.
class Window
{
    private static __gshared bool _loadedLibraries = false;
    private static loadLibraries ()
    {
        if ( !_loadedLibraries ) {
            initGLFW();
            initGL();
            Cursor.createStandardCursors();
        }
        _loadedLibraries = true;
    }

    /// Handles events of all window.
    static void pollEvents ()
    {
        enforce!glfwPollEvents();
    }

    protected GLFWwindow* _window;

    /// Event handlers.
    EventHandler handler;

    ///
    this ( vec2i sz, string text, int hint = WindowHint.None )
    {
        loadLibraries();

        enforce!glfwWindowHint(    GLFW_RESIZABLE, hint & WindowHint.Resizable   );
        enforce!glfwWindowHint(      GLFW_VISIBLE, hint & WindowHint.Visible     );
        enforce!glfwWindowHint(    GLFW_DECORATED, hint & WindowHint.Decorated   );
        enforce!glfwWindowHint(      GLFW_FOCUSED, hint & WindowHint.Focused     );
        enforce!glfwWindowHint( GLFW_AUTO_ICONIFY, hint & WindowHint.AutoIconify );
        enforce!glfwWindowHint(     GLFW_FLOATING, hint & WindowHint.Floating    );
        enforce!glfwWindowHint(    GLFW_MAXIMIZED, hint & WindowHint.Maximized   );

        enforce!glfwWindowHint( GLFW_CONTEXT_VERSION_MAJOR, 3 );
        enforce!glfwWindowHint( GLFW_CONTEXT_VERSION_MINOR, 3 );
        enforce!glfwWindowHint( GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE );

        _window = enforce!glfwCreateWindow(
                sz.x, sz.y, text.toStringz, null, null );
        handler = EventHandler( _window );

        enforce!glfwMakeContextCurrent( _window );
        DerelictGL3.reload();
    }

    ///
    ~this ()
    {
        dispose();
    }
    /// Checks if the window is disposed.
    const @property disposed ()
    {
        return !_window;
    }
    /// Deletes the window.
    void dispose ()
    {
        if ( !disposed ) {
            enforce!glfwDestroyWindow( _window );
        }
        _window = null;
    }

    /// Checks if the window shouldn't close.
    const @property bool alive ()
    {
        return !enforce!glfwWindowShouldClose(
                cast(GLFWwindow*)_window );
    }

    /// Prepares the window to draw.
    /// This method doesn't clear the buffers.
    /// The saved exception at handler will be throwed from here.
    void resetFrame ()
    {
        if ( handler.throwedException ) {
            throw handler.throwedException;
        }
        enforce!glfwMakeContextCurrent( _window );
        DerelictGL3.reload();

        auto size = size;
        enforce!glViewport( 0,0, size.x, size.y );
    }
    /// Swaps the back and front buffers.
    void applyFrame ()
    {
        enforce!glfwSwapBuffers( _window );
    }

    /// Sets title of the window. (writeonly)
    @property void title ( string text )
    {
        enforce!glfwSetWindowTitle( _window, text.toStringz );
    }

    /// Gets position of the window.
    const @property vec2i pos ()
    {
        int x, y;
        enforce!glfwGetWindowPos(
                cast(GLFWwindow*)_window, &x, &y );
        return vec2i(x,y);
    }
    /// Sets position of the window.
    @property void pos ( vec2i p )
    {
        enforce!glfwSetWindowPos( _window, p.x, p.y );
    }

    /// Gets size of the window.
    const @property vec2i size ()
    {
        int w, h;
        enforce!glfwGetWindowSize(
                cast(GLFWwindow*)_window, &w, &h );
        return vec2i(w,h);
    }
    /// Sets size of the window.
    @property void size ( vec2i sz )
    {
        enforce!glfwSetWindowSize( _window, sz.x, sz.y );
    }
    /// Sets aspect ratio of the window.
    @property void aspectRatio ( vec2i ratio )
    {
        enforce!glfwSetWindowAspectRatio(
                _window, ratio.x, ratio.y );
    }
    /// Sets size limitations.
    void setClampSize ( vec2i min, vec2i max )
    {
        enforce!glfwSetWindowSizeLimits(
                _window, min.x, min.y, max.x, max.y );
    }

    /// Sets cursor shape for the window. (writeonly)
    @property void cursor ( in Cursor c )
    {
        enforce!glfwSetCursor(
                _window, cast(GLFWcursor*)c.ptr );
    }

    /// Clipboard text.
    const @property dstring clipboard ()
    {
        return glfwGetClipboardString(
                cast(GLFWwindow*)_window ).to!dstring;
    }
    /// ditto
    @property void clipboard ( dstring v )
    {
        glfwSetClipboardString(
                _window, v.to!string.toStringz );
    }

    /// Shows the hidden window.
    void show ()
    {
        enforce!glfwShowWindow( _window );
    }
    /// Hides the shown window.
    void hide ()
    {
        enforce!glfwHideWindow( _window );
    }
    /// Focuses to the unfocused window.
    void focus ()
    {
        enforce!glfwFocusWindow( _window );
    }
    /// Closes the opened window.
    void close ()
    {
        enforce!glfwSetWindowShouldClose( _window, true );
    }

    /// Minimizes the window.
    void minimize ()
    {
        enforce!glfwIconifyWindow( _window );
    }
    /// Maximizes the window.
    void maximize ()
    {
        enforce!glfwMaximizeWindow( _window );
    }
    /// Restores the window.
    void restore ()
    {
        enforce!glfwRestoreWindow( _window );
    }
}
