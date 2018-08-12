// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module g4d.shader.fragment.rgba;

/// GLSL source code of rgba frag shader.
enum RGBAFragShaderSource = import("g4d/shader/fragment/rgba.glsl");

/// A template for the shader program that uses rgba frag shader.
template RGBAFragShader ()
{
    import g4d.gl.lib,
           g4d.gl.texture;
    import gl3n.linalg;

    override const pure @property string fragSource ()
    {
        return RGBAFragShaderSource;
    }

    protected GLint _imageLoc;

    protected override void initFragShader ()
    {
        _imageLoc = getUniformLoc( "image" );
    }

    override void uploadTexture ( in Texture tex )
    {
        enforce!glActiveTexture( GL_TEXTURE0 );
        tex.bind();
        enforce!glUniform1i( _imageLoc, 0 );
    }
}
