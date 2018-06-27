// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.gl.buffer;
import g4d.gl.lib;

// This is a baseclass that manages buffers of OpenGL.
private abstract class Buffer
{
    protected static Buffer _bindedBuffer;

    protected GLuint _id;
    const @property id () { return _id; }

    // GL_ARRAY_BUFFER, GL_TEXTURE_BUFFER or etc...
    const pure @property GLenum target ();

    this ( void* ptr, size_t sz )
    {
        enforce!glGenBuffers( 1, &_id );
        bind();
        enforce!glBufferData( target, sz, ptr, GL_STATIC_DRAW );
    }
    ~this ()
    {
        enforce!glDeleteBuffers( 1, &_id );
    }

    const @property binded ()
    {
        return _bindedBuffer is this;
    }
    void bind ()
    {
        if ( !binded ) {
            enforce!glBindBuffer( target, _id );
        }
    }

    protected void overwrite ( size_t sz, const void* ptr, size_t offset = 0 )
    {
        bind();
        enforce!glBufferSubData( target, offset, sz, ptr );
    }
}

class ArrayBuffer : Buffer
{
    override const pure @property GLenum target ()
    {
        return GL_ARRAY_BUFFER;
    }

    this ( T ) ( T[] buf )
    {
        size_t size = T.sizeof*buf.length;
        super( buf.ptr, size );
    }

    void overwrite ( T ) ( T[] buf, size_t offset = 0 )
    {
        super.overwrite( T.sizeof*buf.length, buf.ptr, T.sizeof*offset );
    }
}
