// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module g4d.element.text;
import g4d.element.base,
       g4d.ft.font,
       g4d.ft.texture,
       g4d.gl.buffer,
       g4d.shader.base,
       g4d.exception;
import gl3n.linalg;
import std.algorithm,
       std.conv,
       std.math;

/// A struct of character polygon.
private struct CharPoly
{
    ArrayBuffer pos;
    ArrayBuffer uv;
}

/// An element that draws text horizontally.
class HTextElement : Element
{
    protected struct Poly
    {
        dchar c;
        vec2  pos;
        float length;
    }

    protected Poly[]      _polys;
    protected TextTexture _texture;

    protected size_t _polyCnt;

    protected ElementArrayBuffer _indicesBuf;
    protected ArrayBuffer        _posBuf;
    protected ArrayBuffer        _uvBuf;

    /// Polygons to be drawn.
    const @property polys () { return _polys; }

    protected vec2 _size;
    /// Size of area text will be drawn.
    const @property size () { return _size; }

    ///
    this ()
    {
        clear();
    }

    ///
    void clear ()
    {
        _polys   = [];
        _texture = null;
        _size    = vec2(0,0);
    }

    /// Renders the text texture,
    /// And calculates position of each characters.
    void loadText ( FontFace face, dstring text )
    {
        clear();
        if ( text == "" ) return;

        _texture = new TextTexture( face, text );

        float[] posarr, uvarr;
        ushort[] indices;

        auto  curpos   = vec2(0,0);
        const fontsize = face.size.y;

        float  left, top, right, bottom;
        size_t first;

        foreach ( i,c; text ) {
            const metrics = _texture.chars[c];
            auto  poly    = Poly(c);

            left   = curpos.x + metrics.horiBearing.x;
            top    = curpos.y - fontsize + metrics.horiBearing.y;
            right  = left + metrics.size.x;
            bottom = top - metrics.size.y;

            poly.pos    = vec2( left, top );
            poly.length = metrics.horiAdvance;

            posarr ~= [
                left ,top   ,0f,1f,
                right,top   ,0f,1f,
                right,bottom,0f,1f,
                left ,bottom,0f,1f,
            ];
            uvarr ~= metrics.uv;

            first = i*4;
            indices ~= [
                first+0, first+0, // Degenerated
                first+0, first+3, first+1, first+2,
                first+2, // Degenerated
            ].to!(ushort[]);

            _size.x = max( right, _size.x );
            _size.y = max( bottom.abs, _size.y );

            _polys   ~= poly;
            curpos.x += metrics.horiAdvance;
        }
        indices ~= (first+2).to!ushort;

        _polyCnt    = indices.length - 2;
        _indicesBuf = new ElementArrayBuffer( indices );
        _posBuf     = new ArrayBuffer( posarr );
        _uvBuf      = new ArrayBuffer( uvarr  );
    }

    ///
    void draw ( Shader s )
    {
        if ( !_polys.length ) return;
        assert( s && _texture );

        const saver = ShaderStateSaver(s);
        s.applyMatrix();
        s.uploadTexture( _texture );
        s.uploadUvBuffer( _uvBuf );
        s.uploadPositionBuffer( _posBuf );
        s.drawElementsStrip( _indicesBuf, _polyCnt );
    }
}
