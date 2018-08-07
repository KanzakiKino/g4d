// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.glfw.cursor;
import g4d.glfw.lib;
import std.string;

enum CursorShape
{
    Arrow     = GLFW_ARROW_CURSOR,
    IBeam     = GLFW_IBEAM_CURSOR,
    Crosshair = GLFW_CROSSHAIR_CURSOR,
    Hand      = GLFW_HAND_CURSOR,
    HResize   = GLFW_HRESIZE_CURSOR,
    VResize   = GLFW_VRESIZE_CURSOR,
}

private template StandardCursors ()
{
    static foreach ( s; __traits(allMembers,CursorShape) )
    {
        mixin( q{
            protected static Cursor _$name$;
            static @property $name$ () { return _$name$; }
        }.replace( "$name$", s ) );
    }

    static void createStandardCursors ()
    {
        static foreach ( s; __traits(allMembers,CursorShape) )
        {
            mixin( q{
                _$name$ = new Cursor( CursorShape.$name$ );
            }.replace( "$name$", s ) );
        }
    }
}

class Cursor
{
    mixin StandardCursors;

    protected GLFWcursor* _ptr;
    @property ptr () { return _ptr; }

    this ( CursorShape shape )
    {
        _ptr = enforce!glfwCreateStandardCursor( shape );
    }
    ~this ()
    {
        enforce!glfwDestroyCursor( _ptr );
    }
}
