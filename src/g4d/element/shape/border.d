// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module g4d.element.shape.border;
import g4d.element.shape.regular,
       g4d.math.ngon,
       g4d.shader.base;

/// An element of polygons border. N is length of vertex.
class RegularNgonBorderElement ( size_t N ) : RegularNgonElement!(N*2+2)
    if ( N >= 3 )
{
    ///
    this ()
    {
        super();
    }

    ///
    void resize ( float size, float width )
    {
        auto verts = genRegularNgonBorderVertexes( N, size, width );
        assert( verts.length == n );

        foreach ( i,v; verts ) {
            _pos.overwrite( v.scalars, i*4 );
        }
    }

    ///
    override void draw ( Shader s )
    {
        const saver = ShaderStateSaver( s );

        s.uploadPositionBuffer( _pos );
        s.applyMatrix();
        s.drawStrip( n );
    }
}
