// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module g4d.gl.buffer;
import g4d.gl.lib;

/// An enum of buffer usages.
enum BufferUsage
{
    StaticDraw  = GL_STATIC_DRAW,
    DynamicDraw = GL_DYNAMIC_DRAW,
}

/// A baseclass of OpenGL buffers.
abstract class Buffer
{
    protected static Buffer _bindedBuffer;

    /// Not valid buffer id.
    enum NullId = 0;

    protected GLuint _id;
    /// OpenGL buffer id.
    const @property id () { return _id; }

    /// GL_ARRAY_BUFFER, GL_TEXTURE_BUFFER or etc...
    const pure @property GLenum target ();

    ///
    this ( void* ptr, size_t sz, BufferUsage usage )
    {
        enforce!glGenBuffers( 1, &_id );
        bind();
        realloc( ptr, sz, usage );
    }

    ///
    ~this ()
    {
        dispose();
    }
    /// Checks if the buffer is disposed.
    const @property disposed ()
    {
        return _id == NullId;
    }
    /// Deletes buffer.
    void dispose ()
    {
        if ( !disposed ) {
            enforce!glDeleteBuffers( 1, &_id );
        }
        if ( binded ) {
            _bindedBuffer = null;
        }
        _id = NullId;
    }

    /// Checks if the buffer is binded.
    const @property binded ()
    {
        return _bindedBuffer is this;
    }
    /// Sets the buffer binded.
    const void bind ()
    {
        if ( !binded ) {
            enforce!glBindBuffer( target, _id );
        }
    }

    protected void realloc ( in void* ptr, size_t sz, BufferUsage usage )
    {
        bind();
        enforce!glBufferData( target, sz, ptr, usage );
    }

    protected void overwrite ( in void* ptr, size_t sz, size_t offset )
    {
        bind();
        enforce!glBufferSubData( target, offset, sz, ptr );
    }
}

/// A buffer for array data.
/// target property returns GL_ARRAY_BUFFER.
class ArrayBuffer : Buffer
{
    ///
    override const pure @property GLenum target ()
    {
        return GL_ARRAY_BUFFER;
    }

    ///
    this (T) ( T[] buf, BufferUsage usage = BufferUsage.StaticDraw )
    {
        size_t size = T.sizeof*buf.length;
        super( buf.ptr, size, usage );
    }

    /// Reallocates the buffer.
    void realloc (T) ( in T[] buf, BufferUsage usage = BufferUsage.StaticDraw )
    {
        super.realloc( buf.ptr, T.sizeof*buf.length, usage );
    }

    /// Modifies the buffer.
    void overwrite (T) ( in T[] buf, size_t offset = 0 )
    {
        super.overwrite( buf.ptr, T.sizeof*buf.length, T.sizeof*offset );
    }
}

/// A buffer for element array data.
/// target property returns GLL_ELEMENT_ARRAY_BUFFER.
class ElementArrayBuffer : ArrayBuffer
{
    ///
    alias BufferType = ushort;

    ///
    override const pure @property GLenum target ()
    {
        return GL_ELEMENT_ARRAY_BUFFER;
    }

    ///
    this ( BufferType[] buf, BufferUsage usage = BufferUsage.StaticDraw )
    {
        super( buf, usage );
    }
}
