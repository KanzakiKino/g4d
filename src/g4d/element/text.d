// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.element.text;
import g4d.element.base,
       g4d.ft.font,
       g4d.ft.texture,
       g4d.gl.buffer,
       g4d.math.vector,
       g4d.shader.base,
       g4d.exception;
import std.algorithm;

// This is a struct of character polygon.
private struct CharPoly
{
    ArrayBuffer pos;
    ArrayBuffer uv;
}

// This is an element for drawing text horizontally.
class HTextElement : Element
{
    protected struct Poly
    {
        dchar       c;
        vec2        pos;
        float       length;
        ArrayBuffer posBuf;
    }

    protected Poly[]      _polys;
    protected TextTexture _texture;

    const @property polys () { return _polys; }

    protected vec2 _size;

    this ()
    {
        clear();
    }

    override void clear ()
    {
        _polys   = [];
        _texture = null;
        _size    = vec2(0,0);
    }

    void loadText ( FontFace face, dstring text )
    {
        clear();
        _texture = new TextTexture( face, text );

        auto curpos   = vec2(0,0);
        auto fontsize = face.size.y;

        foreach ( c; text ) {
            auto metrics = _texture.chars[c];
            auto poly    = Poly(c);

            auto left   = curpos.x + metrics.horiBearing.x;
            auto top    = curpos.y - fontsize + metrics.horiBearing.y;
            auto right  = left + metrics.size.x;
            auto bottom = top - metrics.size.y;

            _size.x = max( right , _size.x );
            _size.y = max( bottom, _size.y );

            poly.pos    = vec2( left, top );
            poly.length = metrics.horiAdvance;
            poly.posBuf = new ArrayBuffer([
                left ,top   ,0f,1f,
                right,top   ,0f,1f,
                right,bottom,0f,1f,
                left ,bottom,0f,1f,
            ]);

            _polys   ~= poly;
            curpos.x += metrics.horiAdvance;
        }
    }

    override void draw ( Shader s )
    {
        if ( !_polys.length ) return;
        assert( s && _texture );

        auto saver = ShaderStateSaver(s);
        s.applyMatrix();
        s.uploadTexture( _texture );

        foreach ( p; _polys ) {
            auto uv  = _texture.chars[p.c].uv;
            auto pos = p.posBuf;

            s.uploadUvBuffer( uv );
            s.uploadPositionBuffer( pos );
            s.drawFan( 4 );
        }
    }
}
