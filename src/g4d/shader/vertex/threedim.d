// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module g4d.shader.vertex.threedim;

/// GLSL source code of 3d vert shader.
enum ThreeDimVertexShaderSource = import("g4d/shader/vertex/threedim.glsl");

/// A template for the shader program that uses 3d vert shader.
template ThreeDimVertexShader ()
{
    import g4d.gl.buffer,
           g4d.gl.lib;
    import gl3n.linalg;

    override const pure @property string vertexSource ()
    {
        return ThreeDimVertexShaderSource;
    }

    protected GLint _matrixLoc;
    protected GLint _posLoc;
    protected GLint _uvLoc;

    protected override void initVertexShader ()
    {
        _matrixLoc = getUniformLoc( "matrix" );
        _posLoc    = getAttribLoc( "pos" );
        _uvLoc     = getAttribLoc( "uv" );
    }

    override const @property bool textureSupport ()
    {
        return _uvLoc >= 0;
    }

    override void uploadMatrix ( mat4 m )
    {
        enforce!glUniformMatrix4fv( _matrixLoc, 1, GL_TRUE, &m[0][0] );
    }

    override void uploadPositionBuffer ( in ArrayBuffer buf )
    {
        buf.bind();
        enforce!glEnableVertexAttribArray( _posLoc );
        enforce!glVertexAttribPointer( _posLoc, 4, GL_FLOAT, GL_FALSE, 0, null );
    }
    override void uploadUvBuffer ( in ArrayBuffer buf )
    {
        if ( textureSupport ) {
            buf.bind();
            enforce!glEnableVertexAttribArray( _uvLoc );
            enforce!glVertexAttribPointer( _uvLoc, 2, GL_FLOAT, GL_FALSE, 0, null );
        } else {
            super.uploadUvBuffer( buf );
        }
    }
}
