// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.element.shape.regular;
import g4d.element.base,
       g4d.gl.buffer,
       g4d.math.ngon,
       g4d.shader.base;
import gl3n.linalg;
import std.math;

class RegularNgonElement ( size_t N ) : Element
    if ( N > 0 )
{
    alias n = N;

    protected ArrayBuffer _pos;

    this ()
    {
        clear();
    }

    override void clear ()
    {
        _pos = new ArrayBuffer( new float[N*4] );
    }

    void resize ( float size )
    {
        auto verts = genRegularNgonVertexes( N, size );
        foreach ( i,v; verts ) {
            _pos.overwrite( v.vector, i*4 );
        }
    }

    override void draw ( Shader s )
    {
        auto saver = ShaderStateSaver( s );
        s.uploadPositionBuffer( _pos );
        s.applyMatrix();
        s.drawFan( N );
    }

    enum this_is_a_regular_ngon_class_of_g4d = true;
}

enum isRegularNgon(T) =
    __traits(hasMember,T,"this_is_a_regular_ngon_class_of_g4d");
