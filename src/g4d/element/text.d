// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.element.text;
import g4d.element.base,
       g4d.ft.font,
       g4d.gl.buffer,
       g4d.gl.texture,
       g4d.math.vector,
       g4d.shader.base,
       g4d.util.bitmap,
       g4d.exception;
import std.algorithm,
       std.conv;

// This is a struct of character polygon.
private struct CharPoly
{
    ArrayBuffer pos;
    ArrayBuffer uv;
}

// This is an element for drawing text horizontally.
class HTextElement : Element
{
    protected Glyph[]    _glyphs;
    protected Texture    _texture;
    protected CharPoly[] _polys;
    protected size_t     _firstLineHeight;

    vec2  maxSize;
    float lineHeightMag;

    this ()
    {
        clear();

        maxSize       = vec2(0,0);
        lineHeightMag = 1;
    }

    override void clear ()
    {
        _glyphs  = [];
        _texture = null;
        _polys   = [];
    }

    const @property isFixed () { return !!_polys.length; }

    protected void appendChar ( dchar c, FontFace font )
    {
        if ( isFixed ) {
            throw new G4dException( "The text element has been fixed." );
        }
        _glyphs ~= font.render( c );
    }
    void appendText ( dstring text, FontFace font )
    {
        foreach ( c; text ) {
            appendChar( c, font );
        }
    }

    // Creates a texture that is drawn all characters.
    protected Texture createTexture ()
    {
        if ( !_glyphs.length ) {
            return null;
        }
        auto w = _glyphs.map!( x => x.bmp.width ).sum;
        auto h = _glyphs.map!( x => x.bmp.rows  ).maxElement;

        auto   result = new Tex2D( new BitmapA( vec2i(w,h) ) );
        size_t curpos = 0;
        foreach ( g; _glyphs ) {
            result.overwrite( g.bmp, vec2i( curpos, 0 ));
            curpos += g.bmp.width;
        }
        return result;
    }
    // Creates poly from glyph and other parameters.
    protected CharPoly createPolyFromGlyph ( vec2 pos, size_t uvLeft, Glyph g, vec2 texSize )
    {
        CharPoly poly;
        float left   = pos.x + g.bearing.x;
        float top    = pos.y + g.bearing.y;
        float right  = left + g.bmp.width;
        float bottom = top - g.bmp.rows;
        poly.pos = new ArrayBuffer([
                left,top,0f,1f, right,top,0f,1f, right,bottom,0f,1f, left,bottom,0f,1f
        ]);

        left   = uvLeft / texSize.x;
        top    = 0;
        right  = (uvLeft+g.bmp.width) / texSize.x;
        bottom = g.bmp.rows / texSize.y;
        poly.uv = new ArrayBuffer([
                left,top, right,top, right,bottom, left,bottom
        ]);
        return poly;
    }
    // Creates polygons from glyphs and adds it.
    protected void generatePolys ()
    {
        assert( _texture && !isFixed );
        _firstLineHeight = 0;

        auto   texSize    = vec2(_texture.size);
        vec2   pos        = vec2i(0,0);
        size_t uvLeft     = 0;
        size_t lineHeight = 0;

        foreach ( g; _glyphs ) {
            if ( maxSize.x > 0 && pos.x+g.advance > maxSize.x ) {
                pos.x  = 0;
                pos.y -= lineHeight;
                if ( !_firstLineHeight ) {
                    _firstLineHeight = lineHeight;
                }
                if ( maxSize.y > 0 && -pos.y > maxSize.y ) {
                    break;
                }
                lineHeight = 0;
            }
            _polys ~= createPolyFromGlyph( pos, uvLeft, g, texSize );

            pos.x      += g.advance;
            uvLeft     += g.bmp.width;
            lineHeight  = max( lineHeight, g.bmp.rows*lineHeightMag ).to!size_t;
        }
    }
    protected void fix ()
    {
        assert( !isFixed );

        _texture = createTexture();
        if ( _texture ) {
            generatePolys();
        }
        _glyphs  = [];
    }

    override void draw ( Shader s )
    {
        if ( _glyphs.length ) {
            fix();
        }
        if ( !_polys.length ) {
            return;
        }

        s.translate.y -= _firstLineHeight;
        s.applyMatrix();

        s.uploadTexture( _texture );
        foreach ( poly; _polys ) {
            s.uploadPositionBuffer( poly.pos );
            s.uploadUvBuffer( poly.uv );
            s.drawFan( 4 );
        }
    }
}
