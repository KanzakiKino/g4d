// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.gl.type;
import g4d.gl.lib,
       g4d.util.bitmap;
import std.format;

GLenum toGLType ( T ) ()
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

GLenum toBitmapFormat ( T ) ()
    if ( isBitmap!T )
{
    enum lpp = T.lengthPerPixel;
    static if ( lpp == 1 ) {
        return GL_RED;
    } else static if ( lpp == 2 ) {
        return GL_RG;
    } else static if ( lpp == 3 ) {
        return GL_RGB;
    } else static if ( lpp == 4 ) {
        return GL_RGBA;
    } else {
        static assert( false, "%d len/pix is not supported.".format(lpp) );
    }
}
