// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.ft.texture;
import g4d.ft.font,
       g4d.ft.lib,
       g4d.gl.buffer,
       g4d.gl.texture,
       g4d.math.rational,
       g4d.math.vector;
import std.algorithm,
       std.array;

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
    protected static vec2i calcEfficientSize ( Glyph[] g )
    {
        auto glyphs = g.filter!
            (x => x.bmp.width > 0 && x.bmp.rows > 0 ).array;

        auto width = glyphs.map!"a.bmp.width+1".sum;
        if ( glyphs.length ) {
            auto lastWidth = glyphs[$-1].bmp.width;
            width += lastWidth.nextPower2 - lastWidth;
        }
        return vec2i( width, glyphs.map!"a.bmp.rows".maxElement );
    }

    struct Metrics
    {
        vec2i       size;
        ArrayBuffer uv;

        ulong horiAdvance;
        vec2i horiBearing;

        ulong vertAdvance;
        vec2i vertBearing;

        this () @disable;

        protected this ( Glyph g, int leftPix, vec2 texSize )
        {
            size = vec2i( g.bmp.width, g.bmp.rows );

            auto left   = leftPix / texSize.x;
            auto top    = 0f;
            auto right  = (leftPix+size.x) / texSize.x;
            auto bottom = size.y / texSize.y;
            uv = new ArrayBuffer([
                left,top, right,top, right,bottom, left,bottom
            ]);

            horiAdvance = g.advance;
            horiBearing = g.bearing;

            vertAdvance = 0;
            vertBearing = vec2i(0,0); // vert is not supported
        }
    }
    protected Metrics[dchar] _chars;
    @property chars () { return _chars.dup; }

    this ( FontFace face, dstring text )
    {
        auto glyphs = renderGlyphs( face, text );
        super( calcEfficientSize( glyphs.values ) );
        drawGlyphs( glyphs );
    }

    protected void drawGlyphs ( Glyph[dchar] glyphs )
    {
        int pos = 0;
        foreach ( c,g; glyphs ) {
            _chars[c] = Metrics( g, pos, vec2(size) );
            if ( g.bmp.width > 0 && g.bmp.rows > 0 ) {
                overwrite( g.bmp, vec2i(pos,0) );
                pos += g.bmp.width+1;
            }
        }
    }
}
