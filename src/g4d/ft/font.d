// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
 +
 + This module declares utilities related to font.
++/
module g4d.ft.font;
import g4d.ft.lib,
       g4d.util.bitmap,
       g4d.exception;
import gl3n.linalg;
import std.conv,
       std.string;

/// A struct of one glyph.
struct Glyph
{
    /// Bitmap of the glyph.
    BitmapA bmp;
    /// Size of moving from origin.
    vec2i   bearing;
    /// Width of collision.
    size_t  advance;
}

/// An object of Font.
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

    ///
    this ( string path )
    {
        initLibrary();
        _fontCount++;

        enforce!FT_New_Face( _library, path.toStringz, 0, &_face );
    }
    ///
    ~this ()
    {
        enforce!FT_Done_Face( _face );
        if ( --_fontCount <= 0 ) {
            enforce!FT_Done_FreeType( _library );
            _library = null;
        }
    }

    /// Renders the character.
    Glyph render ( vec2i sz, dchar c )
    {
        enforce!FT_Set_Pixel_Sizes( _face, sz.x.to!uint, sz.y.to!uint );

        auto index = FT_Get_Char_Index( _face, c );
        enforce!FT_Load_Glyph( _face, index, FT_LOAD_RENDER );

        auto ftbmp = _face.glyph.bitmap;
        auto size  = vec2i( ftbmp.width.to!int, ftbmp.rows.to!int );
        auto bmp   = new BitmapA( size, ftbmp.buffer );

        auto metrics = _face.glyph.metrics;
        auto bearing = vec2i( metrics.horiBearingX.to!int/64,
                metrics.horiBearingY.to!int/64 );

        return Glyph( bmp, bearing, metrics.horiAdvance/64 );
    }
}

/// An object of font face. Font face knows its size.
class FontFace
{
    protected Font _font;
    /// Font.
    const @property font () { return _font; }

    /// Size of the Font.
    const vec2i size;

    ///
    this ( Font f, vec2i s )
    {
        if ( s.x == 0 ) s.x = s.y;
        if ( s.y == 0 ) s.y = s.x;
        _font = f;
        size  = s;
    }

    /// Renders the character.
    Glyph render ( dchar c )
    {
        return _font.render( size, c );
    }
}
