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

    this ()
    {
        clear();
    }

    override void clear ()
    {
        _glyphs  = [];
        _texture = null;
        _polys   = [];
    }

    const @property isFixed () { return !!_texture; }

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

    protected Texture createTexture ()
    {
        assert( _glyphs.length );

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
    protected void createPolys ()
    {
        assert( _texture );
        auto texSize = vec2(_texture.size);

        float  curpos   = 0;
        size_t curuvpos = 0;
        foreach ( g; _glyphs ) {
            CharPoly poly;
            float left   = curpos + g.bearing.x;
            float top    = g.bearing.y;
            float right  = left + g.bmp.width;
            float bottom = top - g.bmp.rows;
            poly.pos = new ArrayBuffer([
                left,top,0f,1f, right,top,0f,1f, right,bottom,0f,1f, left,bottom,0f,1f
            ]);

            left   = curuvpos / texSize.x;
            top    = 0;
            right  = (curuvpos + g.bmp.width) / texSize.x;
            bottom = g.bmp.rows / texSize.y;
            poly.uv = new ArrayBuffer([
                left,top, right,top, right,bottom, left,bottom
            ]);

            curpos   += g.advance;
            curuvpos += g.bmp.width;
            _polys ~= poly;
        }
    }
    protected void fix ()
    {
        _texture = createTexture();
        createPolys();
        _glyphs  = [];
    }

    override void draw ( Shader s )
    {
        if ( _glyphs.length ) {
            fix();
        }
        if ( _polys.length <= 0 ) {
            return;
        }

        s.uploadTexture( _texture );
        foreach ( poly; _polys ) {
            s.uploadPositionBuffer( poly.pos );
            s.uploadUvBuffer( poly.uv );
            s.drawFan( 4 );
        }
    }
}
