// Written under LGPL-3.0 in the D programming language.
// Copyright 2019 KanzakiKino
module g4d.shader.vertex.threedim;

enum ThreeDimVertexShaderSource = import("shader/vertex/threedim.glsl");

template ThreeDimVertexShader ()
{
    import g4d.gl.buffer,
           g4d.gl.lib,
           g4d.math.matrix;

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

    override @property bool textureSupport ()
    {
        return _uvLoc >= 0;
    }

    override @property void matrix ( mat4 m )
    {
        enforce!glUniformMatrix4fv( _matrixLoc, 1, GL_FALSE, m.ptr );
    }

    override void uploadPositionBuffer ( ArrayBuffer buf )
    {
        buf.bind();
        enforce!glEnableVertexAttribArray( _posLoc );
        enforce!glVertexAttribPointer( _posLoc, 4, GL_FLOAT, GL_FALSE, 0, null );
    }
    override void uploadUvBuffer ( ArrayBuffer buf )
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
