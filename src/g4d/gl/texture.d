// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module g4d.gl.texture;
import g4d.gl.lib,
       g4d.gl.type,
       g4d.math.rational,
       g4d.util.bitmap;
import gl3n.linalg;
import std.conv;

/// A baseclass of OpenGL texture.
abstract class Texture
{
    protected static Texture _bindedTexture;

    /// Invalid texture id.
    enum NullId = 0;

    protected GLuint _id;
    /// OpenGL texture id.
    const @property id () { return _id; }

    /// Size of this texture.
    immutable vec2i size;

    /// GL_TEXTURE_2D, etc...
    const pure @property GLenum target ();

    ///
    this ( vec2i sz )
    {
        size = sz;

        enforce!glGenTextures( 1, &_id );
        bind();

        enforce!glTexParameteri( target, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
        enforce!glTexParameteri( target, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    }

    ///
    ~this ()
    {
        dispose();
    }
    /// Checks if the texture is disposed.
    const @property disposed ()
    {
        return _id == NullId;
    }
    /// Deletes the texture.
    void dispose ()
    {
        if ( !disposed ) {
            enforce!glDeleteTextures( 1, &_id );
        }
        if ( binded ) {
            _bindedTexture = null;
        }
        _id = NullId;
    }

    /// Checks if the texture is binded.
    const @property binded ()
    {
        return _bindedTexture is this;
    }
    /// Sets the texture binded.
    const void bind ()
    {
        if ( !binded ) {
            enforce!glBindTexture( target, id );
            _bindedTexture = cast(Texture) this;
        }
    }
}

/// A 2-dimensional texture.
/// target returns GL_TEXTURE_2D.
class Tex2D : Texture
{
    protected static auto resizeBitmapPower2 (B) ( in B bmp )
        if ( isBitmap!B )
    {
        auto sz = vec2i( bmp.width.nextPower2.to!int,
                bmp.rows.nextPower2.to!int );
        return bmp.conservativeResize( sz );
    }

    ///
    override const pure @property GLenum target ()
    {
        return GL_TEXTURE_2D;
    }

    ///
    this (B) ( in B bmp, bool compress = false )
        if ( isBitmap!B )
    {
        auto formatted = resizeBitmapPower2( bmp );

        super( formatted.size );
        enum type = toGLType!(B.Type);
        enum lpp  = B.LengthPerPixel;

        enum  srcFormat = lpp.toFormat;
        const texFormat = compress?
            lpp.toCompressedFormat: srcFormat;

        enforce!glTexImage2D( target, 0, texFormat,
                size.x, size.y, 0, srcFormat, type, formatted.data );
        formatted.dispose();
    }

    /// Creates an empty texture.
    /// Compressing is not allowed,
    /// because compressed texture cannot use glTexSubImage2D.
    this ( vec2i sz, uint lpp = 4 )
    {
        super( vec2i( sz.x.nextPower2, sz.y.nextPower2 ) );

        enforce!glTexImage2D( target, 0, lpp.toFormat,
                size.x, size.y, 0, GL_RED,
                GL_UNSIGNED_BYTE, null );
    }

    /// Modifies the texture.
    void overwrite (B) ( in B bmp, vec2i offset = vec2i(0,0) )
        if ( isBitmap!B )
    {
        auto formatted = resizeBitmapPower2( bmp );
        scope(exit) formatted.dispose();

        enum  type    = toGLType!(B.bitType);
        enum  format  = B.lengthPerPixel.toFormat;
        const bmpSize = formatted.size;

        bind();
        enforce!glTexSubImage2D( target, 0, offset.x, offset.y,
                bmpSize.x, bmpSize.y, format, type, formatted.data );
    }
}
