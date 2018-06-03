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

    protected GLuint _id;
    @property id () { return _id; }

    const pure @property GLenum target ();

    this ()
    {
        enforce!glGenTextures( 1, &_id );
        bind();

        enforce!glTexParameteri( target, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
        enforce!glTexParameteri( target, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    }
    ~this ()
    {
        enforce!glDeleteTextures( 1, &_id );
    }

    const @property binded ()
    {
        return _bindedTexture is this;
    }
    void bind ()
    {
        if ( !binded ) {
            enforce!glBindTexture( target, _id );
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
        auto src  = bmp.ptr;

        auto dstw   = srcw.nextPower2, dsth = srch.nextPower2;
        auto result = new B( vec2i(dstw,dsth) );
        auto dst    = result.ptr;

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

    this ( B ) ( B bmp )
        if ( isBitmap!B )
    {
        bmp = resizeBitmapPower2( bmp );

        super();
        enum type = toGLType!(B.bitType);
        enum format = toBitmapFormat!B;

        enforce!glTexImage2D( target, 0, GL_RGBA,
                bmp.width.to!int, bmp.rows.to!int, 0, format, type, bmp.ptr );
    }

    void overwrite ( B ) ( B bmp, Size offset = Size(0,0) )
        if ( isBitmap!B )
    {
        bmp = resizeBitmapPower2( bmp );

        bind();
        enum type = toGLType!(B.bitType);
        enum format = toBitmapFormat!B;
        enforce!glTexSubImage2D( target, 0, offset.x.to!int, offset.y.to!int,
                bmp.width, bmp.rows, format, type, bmp.ptr );
    }
}
