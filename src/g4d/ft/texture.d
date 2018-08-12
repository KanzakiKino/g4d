// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.ft.texture;
import g4d.ft.font,
       g4d.ft.lib,
       g4d.gl.buffer,
       g4d.gl.texture,
       g4d.math.rational,
       g4d.util.bitmap;
import gl3n.linalg;
import std.algorithm,
       std.array,
       std.conv;

class TextTexture : Tex2D
{
    protected static Glyph[dchar] renderGlyphs ( FontFace face, dstring text )
    {
        Glyph[dchar] result;

        foreach ( c; text ) {
            if ( c !in result ) {
                result[c] = face.render( c );
            }
        }
        return result;
    }

    struct Metrics
    {
        protected int pos;

        vec2i       size;
        ArrayBuffer uv;

        ulong horiAdvance;
        vec2i horiBearing;

        ulong vertAdvance;
        vec2i vertBearing;
    }
    protected Metrics[dchar] _chars;
    @property chars () { return _chars.dup; }

    this ( FontFace face, dstring text )
    {
        auto glyphs = renderGlyphs( face, text );
        super( renderBitmap( glyphs ), true );
    }

    protected vec2i placeGlyphs ( Glyph[dchar] glyphs )
    {
        Metrics m;
        auto size = vec2i(0,0);
        foreach ( c, g; glyphs ) {
            m.pos         = size.x;
            m.size        = g.bmp.size;
            m.uv          = null;
            m.horiAdvance = g.advance;
            m.horiBearing = g.bearing;
            m.vertAdvance = 0;
            m.vertBearing = vec2i(0,0);

            _chars[c] = m;

            size.x += g.bmp.width + 1;
            size.y  = max( size.y, g.bmp.rows ).to!int;
        }
        return size;
    }

    protected BitmapA renderBitmap ( Glyph[dchar] glyphs )
    {
        auto size   = placeGlyphs( glyphs );
        auto result = new BitmapA( size );

        size.x = size.x.nextPower2;
        size.y = size.y.nextPower2;

        Metrics* m;
        float left, top, right, bottom;

        foreach ( c, g; glyphs ) {
            m = &_chars[c];
            result.overwrite( vec2i(m.pos,0), g.bmp );

            left   = m.pos*1f/size.x;
            top    = 0;
            right  = left + m.size.x*1f/size.x;
            bottom = m.size.y*1f/size.y;

            m.uv = new ArrayBuffer( [
                left,top, right,top, right,bottom, left,bottom,
            ] );
        }
        return result;
    }
}
