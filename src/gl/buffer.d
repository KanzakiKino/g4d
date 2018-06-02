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

    this ()
    {
        enforce!glGenBuffers( 1, &_id );
    }

    const @property binded ()
    {
        return _bindedBuffer == this;
    }
    void bind ()
    {
        if ( !binded ) {
            enforce!glBindBuffer( target, _id );
        }
    }

    void assign ( size_t sz, void* ptr, size_t offset = 0 )
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
        super();
        bind();

        auto size = T.sizeof*buf.length;
        enforce!glBufferData( target, size, buf.ptr, GL_STATIC_DRAW );
    }
    ~this ()
    {
        enforce!glDeleteBuffers( 1, &_id );
    }

    void assign ( T ) ( T[] buf, size_t offset = 0 )
    {
        assign( T.sizeof*buf.length, buf.ptr, offset );
    }
}
