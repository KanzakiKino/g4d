// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.glfw.handler;
import g4d.glfw.lib,
       g4d.glfw.type,
       g4d.math.vector;
import std.string;

alias WindowMoveHandler    = void delegate ( vec2i );
alias WindowResizeHandler  = void delegate ( vec2i );
alias WindowCloseHandler   = void delegate ();
alias WindowRefreshHandler = void delegate ();
alias WindowFocusHandler   = void delegate ( bool );
alias WindowIconifyHandler = void delegate ( bool );
alias FbResizeHandler      = void delegate ( vec2i );

alias MouseButtonHandler = void delegate ( MouseButton, bool );
alias MouseMoveHandler   = void delegate ( vec2 );
alias MouseEnterHandler  = void delegate ( bool );
alias MouseScrollHandler = void delegate ( vec2 );
alias KeyHandler         = void delegate ( Key, KeyState );
alias CharacterHandler   = void delegate ( dchar );

struct EventHandler
{
    Exception throwedException = null;

    WindowMoveHandler    onWindowMove    = null;
    WindowResizeHandler  onWindowResize  = null;
    WindowCloseHandler   onWindowClose   = null;
    WindowRefreshHandler onWindowRefresh = null;
    WindowFocusHandler   onWindowFocus   = null;
    WindowIconifyHandler onWindowIconify = null;
    FbResizeHandler      onFbResize      = null;

    MouseButtonHandler onMouseButton = null;
    MouseMoveHandler   onMouseMove   = null;
    MouseEnterHandler  onMouseEnter  = null;
    MouseScrollHandler onMouseScroll = null;
    KeyHandler         onKey         = null;
    CharacterHandler   onCharacter   = null;

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
                    try {
                        ptr.%HANDLER%( %HANDLER_ARGS% );
                    } catch ( Exception e ) {
                        ptr.throwedException = e;
                    }
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

    private static extern(C) GLFWmousebuttonfun __mb =
        mixin( genFunc( "onMouseButton", q{int b, int a, int m}, q{cast(MouseButton)b, a == GLFW_PRESS} ) );
    private static extern(C) GLFWcursorposfun __mm =
        mixin( genFunc( "onMouseMove", q{double x, double y}, q{vec2(x,y)} ) );
    private static extern(C) GLFWcursorenterfun __me =
        mixin( genFunc( "onMouseEnter", q{int t}, q{t == GLFW_TRUE} ) );
    private static extern(C) GLFWscrollfun __ms =
        mixin( genFunc( "onMouseScroll", q{double x, double y}, q{vec2(x,y)} ) );
    private static extern(C) GLFWkeyfun __k =
        mixin( genFunc( "onKey", q{int k, int code, int a, int m}, q{cast(Key)k, cast(KeyState)a} ) );
    private static extern(C) GLFWcharfun __c =
        mixin( genFunc( "onCharacter", q{uint c}, q{cast(dchar)c} ) );

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

        enforce!glfwSetMouseButtonCallback( win, __mb );
        enforce!glfwSetCursorPosCallback  ( win, __mm );
        enforce!glfwSetCursorEnterCallback( win, __me );
        enforce!glfwSetScrollCallback     ( win, __ms );
        enforce!glfwSetKeyCallback        ( win, __k );
        enforce!glfwSetCharCallback       ( win, __c );
    }
}
