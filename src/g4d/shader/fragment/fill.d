// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module g4d.shader.fragment.fill;

/// GLSL source code of fill frag shader.
enum FillFragShaderSource = import("g4d/shader/fragment/fill.glsl");

/// A template for the shader program that uses fill frag shader.
template FillFragShader ()
{
    import g4d.gl.lib;
    import gl3n.linalg;

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
