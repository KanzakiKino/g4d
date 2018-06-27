// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.math.ngon;
import g4d.math.matrix,
       g4d.math.vector;
import std.math;

vec4[] genRegularNgonVertexes ( size_t n, float size )
{
    vec4[] result;

    auto pos = vec4( 0f, size, 0f, 1f );
    auto mat = mat4.rotation( 0, 0, PI*2f/n );

    for ( size_t i = 0; i < n; i++ ) {
        result ~= pos;
        pos = vec4( mat * pos.toMatrix );
    }
    return result;
}

vec4[] genRegularNgonBorderVertexes ( size_t n, float size, float width )
{
    vec4[] result;

    auto shape = genRegularNgonVertexes( n, size );
    if ( shape.length > 0 ) {
        shape ~= shape[0];
    }
    auto ratio = 1f - width*1f/size;

    foreach ( v; shape ) {
        result ~= v;
        result ~= vec4( v.x*ratio, v.y*ratio, v.z, v.w );
    }
    return result;
}
