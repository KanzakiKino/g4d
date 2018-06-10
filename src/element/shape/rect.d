// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.element.shape.rect;
import g4d.element.shape.regular,
       g4d.gl.buffer,
       g4d.math.vector;

class RectElement : RegularNgonElement!4
{
    this ()
    {
        super();
    }

    void resize ( vec2 sz )
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
            0f,1f, 1f,1f, 1f,0f, 0f,0f,
        ]);
    }
}
