// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module g4d.element.shape.regular;
import g4d.element.base,
       g4d.gl.buffer,
       g4d.math.ngon,
       g4d.shader.base;
import gl3n.linalg;
import std.math;

/// An element of polygons.
class RegularNgonElement ( size_t _N ) : Element
    if ( _N >= 3 )
{
    /// Length of vertexes.
    alias N = _N;

    protected ArrayBuffer _pos;

    ///
    this ()
    {
        _pos = new ArrayBuffer( new float[N*4],
               BufferUsage.DynamicDraw );
    }

    ///
    void clear ()
    {
        _pos.overwrite( new float[N*4] );
    }

    ///
    void resize ( float size )
    {
        auto verts = genRegularNgonVertexes( N, size );
        foreach ( i,v; verts ) {
            _pos.overwrite( v.vector, i*4 );
        }
    }

    ///
    void draw ( Shader s )
    {
        const saver = ShaderStateSaver( s );
        s.uploadPositionBuffer( _pos );
        s.applyMatrix();
        s.drawFan( N );
    }

    /// To prove this type.
    enum this_is_a_regular_ngon_class_of_g4d = true;
}

/// Checks if T is RegularNgonElement.
enum isRegularNgon(T) =
    __traits(hasMember,T,"this_is_a_regular_ngon_class_of_g4d");
