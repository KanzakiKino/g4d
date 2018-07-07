// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.element.shape.border;
import g4d.element.shape.regular,
       g4d.math.ngon,
       g4d.shader.base;

class RegularNgonBorderElement ( size_t N ) : RegularNgonElement!(N*2+2)
    if ( N > 0 )
{
    this ()
    {
        super();
    }

    void resize ( float size, float width )
    {
        auto verts = genRegularNgonBorderVertexes( N, size, width );
        assert( verts.length == n );

        foreach ( i,v; verts ) {
            _pos.overwrite( v.scalars, i*4 );
        }
    }

    override void draw ( Shader s )
    {
        auto saver = ShaderStateSaver( s );
        s.uploadPositionBuffer( _pos );
        s.applyMatrix();
        s.drawStrip( n );
    }
}
