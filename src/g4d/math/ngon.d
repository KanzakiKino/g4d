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
{
    assert( n >= 3, "Vertex must be 3 or more." );

    auto result = new vec4[n];

    auto  pos = vec4( 0f, size, 0f, 1f );
    const mat = mat4.zrotation( PI*2f/n );

    foreach ( ref v; result ) {
        v   = pos;
        pos = mat * pos;
    }
    return result;
}

/// Returns positions of regular polygons' border's vertexes.
vec4[] genRegularNgonBorderVertexes ( size_t n, float size, float width )
{
    assert( n >= 3, "Vertex must be 3 or more." );

    const vertexLen = n*2+2;
    auto  result    = new vec4[vertexLen];

    auto  pos = vec4( 0f, size, 0f, 1f );
    const mat = mat4.zrotation( PI*2f/n );

    const ratio = 1f - width*1f/size;

    for ( size_t i = 0; i < vertexLen; ) {
        result[i++] = pos;
        result[i++] = vec4( pos.x*ratio, pos.y*ratio, pos.z, pos.w );

        pos = mat * pos;
    }
    return result;
}
