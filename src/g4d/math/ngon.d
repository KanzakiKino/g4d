// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module g4d.math.ngon;
import gl3n.linalg;
import std.math;

/// Returns positions of regular polygons' vertexes.
vec4[] genRegularNgonVertexes ( size_t n, float size )
{ // TODO: optimize
    vec4[] result;

    auto  pos = vec4( 0f, size, 0f, 1f );
    const mat = mat4.zrotation( PI*2f/n );

    for ( size_t i = 0; i < n; i++ ) {
        result ~= pos;
        pos     = mat * pos;
    }
    return result;
}

/// Returns positions of regular polygons' border's vertexes.
vec4[] genRegularNgonBorderVertexes ( size_t n, float size, float width )
{
    vec4[] result;

    auto shape = genRegularNgonVertexes( n, size );
    if ( shape.length > 0 ) {
        shape ~= shape[0];
    }
    const ratio = 1f - width*1f/size;

    foreach ( v; shape ) {
        result ~= v;
        result ~= vec4( v.x*ratio, v.y*ratio, v.z, v.w );
    }
    return result;
}
