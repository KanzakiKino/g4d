// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module g4d.shader.fragment.alpha;

/// Source of the alpha frag shader.
enum AlphaFragShaderSource = import("g4d/shader/fragment/alpha.glsl");

/// A template for the shader program that uses alpha frag shader.
template AlphaFragShader ()
{
    import g4d.gl.lib,
           g4d.gl.texture;
    import gl3n.linalg;

    override const pure @property string fragSource ()
    {
        return AlphaFragShaderSource;
    }

    protected GLint _imageLoc;
    protected GLint _colorLoc;

    protected override void initFragShader ()
    {
        _imageLoc = getUniformLoc( "image" );
        _colorLoc = getUniformLoc( "color" );
    }

    @property void color ( vec4 col )
    {
        enforce!glUniform4f( _colorLoc, col.r, col.g, col.b, col.a );
    }
    override void uploadTexture ( in Texture tex )
    {
        enforce!glActiveTexture( GL_TEXTURE0 );
        tex.bind();
        enforce!glUniform1i( _imageLoc, 0 );
    }
}
