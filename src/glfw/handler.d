// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.glfw.handler;
import g4d.glfw.lib,
       g4d.math.vector;
import std.string;

alias WindowMoveHandler    = nothrow void delegate ( vec2i );
alias WindowResizeHandler  = nothrow void delegate ( vec2i );
alias WindowCloseHandler   = nothrow void delegate ();
alias WindowRefreshHandler = nothrow void delegate ();
alias WindowFocusHandler   = nothrow void delegate ( bool );
alias WindowIconifyHandler = nothrow void delegate ( bool );
alias FbResizeHandler      = nothrow void delegate ( vec2i );

struct EventHandler
{
    WindowMoveHandler    onWindowMove    = null;
    WindowResizeHandler  onWindowResize  = null;
    WindowCloseHandler   onWindowClose   = null;
    WindowRefreshHandler onWindowRefresh = null;
    WindowFocusHandler   onWindowFocus   = null;
    WindowIconifyHandler onWindowIconify = null;
    FbResizeHandler      onFbResize      = null;

    protected static pure string genFunc ( string handler, string args = "", string hndlargs = "" )
    {
        if ( args != "" ) {
            args = ','~args;
        }
        return q{
            function ( GLFWwindow* win %ARGS% ) nothrow
            {
                auto ptr = cast(EventHandler*) glfwGetWindowUserPointer( win );
                if ( ptr.%HANDLER% ) {
                    ptr.%HANDLER%( %HANDLER_ARGS% );
                }
            }
        }
        .replace( "%HANDLER%", handler )
        .replace( "%ARGS%", args )
        .replace( "%HANDLER_ARGS%", hndlargs );
    }

    private static extern(C) GLFWwindowposfun __wp =
        mixin( genFunc( "onWindowMove", q{int x,int y}, q{vec2i(x,y)} ) );
    private static extern(C) GLFWwindowsizefun __ws =
        mixin( genFunc( "onWindowResize", q{int x,int y}, q{vec2i(x,y)} ) );
    private static extern(C) GLFWwindowclosefun __wc =
        mixin( genFunc( "onWindowClose" ) );
    private static extern(C) GLFWwindowrefreshfun __wr =
        mixin( genFunc( "onWindowRefresh" ) );
    private static extern(C) GLFWwindowfocusfun __wf =
        mixin( genFunc( "onWindowFocus", q{int t}, q{t == GLFW_TRUE} ) );
    private static extern(C) GLFWwindowfocusfun __wi =
        mixin( genFunc( "onWindowIconify", q{int t}, q{t == GLFW_TRUE} ) );
    private static extern(C) GLFWframebuffersizefun __fs =
        mixin( genFunc( "onFbResize", q{int x, int y}, q{vec2i(x,y)} ) );

    this ( GLFWwindow* win )
    {
        enforce!glfwSetWindowUserPointer( win, &this );

        enforce!glfwSetWindowPosCallback      ( win, __wp );
        enforce!glfwSetWindowSizeCallback     ( win, __ws );
        enforce!glfwSetWindowCloseCallback    ( win, __wc );
        enforce!glfwSetWindowRefreshCallback  ( win, __wr );
        enforce!glfwSetWindowFocusCallback    ( win, __wf );
        enforce!glfwSetWindowIconifyCallback  ( win, __wi );
        enforce!glfwSetFramebufferSizeCallback( win, __fs );
    }
}
