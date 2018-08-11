// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.gl.texture;
import g4d.gl.lib,
       g4d.gl.type,
       g4d.math.rational,
       g4d.math.vector,
       g4d.util.bitmap;
import std.conv;

abstract class Texture
{
    protected static Texture _bindedTexture;

    const GLuint id;
    const vec2i  size;

    const pure @property GLenum target ();

    this ( vec2i sz )
    {
        size = sz;

        GLuint temp;
        enforce!glGenTextures( 1, &temp );
        id = temp;
        bind();

        enforce!glTexParameteri( target, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
        enforce!glTexParameteri( target, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    }

    ~this ()
    {
        dispose();
    }
    void dispose ()
    {
        enforce!glDeleteTextures( 1, &id );
    }

    const @property binded ()
    {
        return _bindedTexture is this;
    }
    void bind ()
    {
        if ( !binded ) {
            enforce!glBindTexture( target, id );
            _bindedTexture = this;
        }
    }
}

class Tex2D : Texture
{
    protected static B resizeBitmapPower2 ( B ) ( B bmp )
        if ( isBitmap!B )
    {
        auto sz = vec2i( bmp.width.nextPower2,
                bmp.rows.nextPower2 );
        return bmp.conservativeResize( sz );
    }

    override const pure @property GLenum target ()
    {
        return GL_TEXTURE_2D;
    }

    this ( B ) ( B bmp, bool compress = false )
        if ( isBitmap!B )
    {
        bmp = resizeBitmapPower2( bmp );

        super( vec2i( bmp.width, bmp.rows ) );
        enum type = toGLType!(B.bitType);
        enum lpp  = B.lengthPerPixel;

        enum  srcFormat = lpp.toFormat;
        const texFormat = compress?
            lpp.toCompressedFormat: srcFormat;

        enforce!glTexImage2D( target, 0, texFormat,
                bmp.width.to!int, bmp.rows.to!int, 0, srcFormat, type, bmp.data );
        bmp.dispose();
    }

    // Cannot compress empty texture
    // because compressed texture cannot use glTexSubImage2D.
    this ( vec2i sz, uint lpp = 4 )
    {
        super( vec2i( sz.x.nextPower2, sz.y.nextPower2 ) );

        auto size = vec2i(size);
        auto ptr  = new ubyte[size.x*size.y];

        enforce!glTexImage2D( target, 0, lpp.toFormat,
                size.x, size.y, 0, GL_RED,
                GL_UNSIGNED_BYTE, ptr.ptr );
    }

    void overwrite ( B ) ( B bmp, vec2i offset = vec2i(0,0) )
        if ( isBitmap!B )
    {
        bmp = resizeBitmapPower2( bmp );

        bind();
        enum type   = toGLType!(B.bitType);
        enum format = B.lengthPerPixel.toFormat;
        enforce!glTexSubImage2D( target, 0, offset.x.to!int, offset.y.to!int,
                bmp.width.to!int, bmp.rows.to!int, format, type, bmp.data );
        bmp.dispose();
    }
}
