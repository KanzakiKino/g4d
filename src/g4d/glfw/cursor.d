// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module g4d.glfw.cursor;
import g4d.glfw.lib;
import std.string;

/// A type of cursor shape.
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

/// An object of cursor image.
/// You can access standard cursor without creating instance.
/// Examples: setCursor( Cursor.IBeam );
class Cursor
{
    mixin StandardCursors;

    protected GLFWcursor* _ptr;
    /// Pointer to glfw cursor.
    const @property ptr () { return _ptr; }

    ///
    this ( CursorShape shape )
    {
        _ptr = enforce!glfwCreateStandardCursor( shape );
    }

    ///
    ~this ()
    {
        dispose();
    }
    /// Checks if the cursor is disposed.
    const @property disposed ()
    {
        return !_ptr;
    }
    /// Deletes glfw cursor.
    void dispose ()
    {
        if ( !disposed ) {
            enforce!glfwDestroyCursor( _ptr );
        }
        _ptr = null;
    }
}
