// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.ft.font;
import g4d.ft.lib,
       g4d.math.vector,
       g4d.util.bitmap,
       g4d.exception;
import std.string;

class Font
{
    protected static FT_Library _library;
    protected static void initLibrary ()
    {
        if ( !_library ) {
            DerelictFT.load();
            enforce!FT_Init_FreeType( &_library );
        }
    }
    protected static size_t _fontCount;

    protected FT_Face _face;

    this ( string path )
    {
        initLibrary();
        _fontCount++;

        enforce!FT_New_Face( _library, path.toStringz, 0, &_face );
    }
    ~this ()
    {
        enforce!FT_Done_Face( _face );
        if ( --_fontCount <= 0 ) {
            enforce!FT_Done_FreeType( _library );
            _library = null;
        }
    }

    BitmapA render ( vec2i sz, dchar c )
    {
        throw new G4dException( "Not Implemented" );
    }
}

class FontFace
{
    protected Font   _font;
    @property ref font () { return _font; }

    protected vec2i _size;
    @property ref size () { return _size; }

    this ( Font f, vec2i s )
    {
        _font = f;
        _size = s;
    }

    BitmapA render ( dchar c )
    {
        return _font.render( _size, c );
    }
}
