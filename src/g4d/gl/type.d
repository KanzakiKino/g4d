// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module g4d.gl.type;
import g4d.gl.lib,
       g4d.util.bitmap;
import std.format;

/// Converts vartypes to GLenum.
GLenum toGLType (T) ()
{
    static if ( is(T==ubyte) ) {
        return GL_UNSIGNED_BYTE;
    } else static if ( is(T==byte) ) {
        return GL_BYTE;
    } else static if ( is(T==ushort) ) {
        return GL_UNSIGNED_SHORT;
    } else static if ( is(T==short) ) {
        return GL_SHORT;
    } else static if ( is(T==uint) ) {
        return GL_UNSIGNED_INT;
    } else static if ( is(T==int) ) {
        return GL_INT;
    } else static if ( is(T==float) ) {
        return GL_FLOAT;
    } else {
        enum typeName = __traits(identifier,T);
        static assert( false, "Failed converting %s to GL_*.".format(typeName) );
    }
}

/// Converts length per pixel to GLenum(pixel format).
/// Examples: assert( 4.toFormat == GL_RGBA );
GLenum toFormat ( uint lpp )
{
    assert( lpp > 0 && lpp <= 4 );
    return lpp==1? GL_RED :
           lpp==2? GL_RG  :
           lpp==3? GL_RGB :
           lpp==4? GL_RGBA:
           0;
}

/// Converts length per pixel to GLenum(compressed pixel format).
/// Examples: assert( 4.toCompressedFormat == GL_COMPRESSED_RGBA );
GLenum toCompressedFormat ( uint lpp )
{
    assert( lpp > 0 && lpp <= 4 );
    return lpp==1? GL_COMPRESSED_RED :
           lpp==2? GL_COMPRESSED_RG  :
           lpp==3? GL_COMPRESSED_RGB :
           lpp==4? GL_COMPRESSED_RGBA:
           0;
}
