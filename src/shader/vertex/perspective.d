// Written under LGPL-3.0 in the D programming language.
// Copyright 2019 KanzakiKino
module g4d.shader.vertex.perspective;

enum PerspectiveVertexShaderSource = import("shader/vertex/perspective.glsl");

template PerspectiveVertexShader ()
{
    import g4d.gl.buffer,
           g4d.gl.lib;

    override const pure @property string vertexSource ()
    {
        return PerspectiveVertexShaderSource;
    }

    protected GLint _posLoc;

    protected override void initVertexShader ()
    {
        _posLoc = getAttribLoc( "pos" );
    }

    override void uploadPositionBuffer ( ArrayBuffer buf )
    {
        buf.bind();
        enforce!glEnableVertexAttribArray( _posLoc );
        enforce!glVertexAttribPointer( _posLoc, 4, GL_FLOAT, GL_FALSE, 0, null );
    }
}
