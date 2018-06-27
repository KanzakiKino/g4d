// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.shader.fragment.fill;

enum FillFragShaderSource = import("g4d/shader/fragment/fill.glsl");

template FillFragShader ()
{
    import g4d.gl.lib,
           g4d.math.vector;

    override const pure @property string fragSource ()
    {
        return FillFragShaderSource;
    }

    protected GLint _colorLoc;

    protected override void initFragShader ()
    {
        _colorLoc = getUniformLoc( "color" );
    }

    @property void color ( vec4 col )
    {
        enforce!glUniform4f( _colorLoc, col.r, col.g, col.b, col.a );
    }
}
