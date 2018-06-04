// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.ft.font;
import g4d.ft.lib;
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
}
