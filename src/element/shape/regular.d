// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.element.shape.regular;
import g4d.element.base,
       g4d.gl.buffer,
       g4d.math.matrix,
       g4d.math.vector,
       g4d.shader.base;
import std.math;

class RegularNgonElement ( ubyte N ) : Element
    if ( N > 0 )
{
    protected ArrayBuffer _pos;
    protected ArrayBuffer _uv;

    this ()
    {
        clear();
    }

    override void clear ()
    {
        _pos = new ArrayBuffer( new float[N*4] );
        _uv  = new ArrayBuffer( new float[N*2] );
    }

    void resize ( float sz )
    {
        auto pos = vec4( 0, sz, 0, 1 );
        auto mat = mat4.rotation( 0f, 0f, 2f*PI/N );

        static foreach ( i; 0..N )
        {
            _pos.overwrite(       pos.scalars, i*4 );
            _uv .overwrite( pos.scalars[0..2], i*2 );
            pos = vec4( mat*pos.toMatrix );
        }
    }

    override void draw ( Shader s )
    {
        s.uploadPositionBuffer( _pos );
        if (s.textureSupport ) {
            s.uploadUvBuffer( _uv );
        }
        s.applyMatrix();
        s.drawFan( N );
    }

    enum this_is_a_regular_ngon_class_of_g4d = true;
}

enum isRegularNgon(T) =
    __traits(hasMember,T,"this_is_a_regular_ngon_class_of_g4d");
