// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.element.shape.rect;
import g4d.element.shape.regular,
       g4d.gl.buffer,
       g4d.math.vector,
       g4d.shader.base;

class RectElement : RegularNgonElement!4
{
    protected ArrayBuffer _uv;

    this ()
    {
        super();
    }

    override void clear ()
    {
        super.clear();
        _uv = new ArrayBuffer( new float[n*2] );
    }

    void resize ( vec2 sz, vec2 uv = vec2(1f,1f) )
    {
        auto halfW = sz.x/2;
        auto halfH = sz.y/2;

        _pos.overwrite([
            -halfW,  halfH, 0, 1,
             halfW,  halfH, 0, 1,
             halfW, -halfH, 0, 1,
            -halfW, -halfH, 0, 1,
        ]);
        _uv.overwrite([
            0f,0f, uv.x,0f, uv.x,uv.y, 0f,uv.y,
        ]);
    }

    override void draw ( Shader s )
    {
        if ( s.textureSupport ) {
            s.uploadUvBuffer( _uv );
        }
        super.draw(s);
    }
}