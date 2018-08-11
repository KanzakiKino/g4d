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
        enum lpp = bmp.lengthPerPixel;

        auto srcw = bmp.width, srch = bmp.rows;
        auto src  = bmp.data;

        auto dstw   = srcw.nextPower2, dsth = srch.nextPower2;
        auto result = new B( vec2i(dstw,dsth) );
        auto dst    = result.data;

        size_t x = 0, y = 0, i = 0, srci = 0, dsti = 0;
        for ( y = 0; y < dsth; y++ ) {
            for ( x = 0; x < dstw; x++ ) {
                if ( x >= srcw || y >= srch ) {
                    for ( i = 0; i < lpp; i++ ) {
                        dst[dsti++] = 0;
                    }
                } else {
                    for ( i = 0; i < lpp; i++ ) {
                        dst[dsti++] = src[srci++];
                    }
                }
            }
        }
        return result;
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
            lpp.toCompressedFomrat: srcFormat;

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
