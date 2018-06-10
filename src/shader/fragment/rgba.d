// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.shader.fragment.rgba;

enum RGBAFragShaderSource = import("shader/fragment/rgba.glsl");

template RGBAFragShader ()
{
    import g4d.gl.lib,
           g4d.gl.texture,
           g4d.math.vector;

    override const pure @property string fragSource ()
    {
        return RGBAFragShaderSource;
    }

    protected GLint _imageLoc;

    protected override void initFragShader ()
    {
        _imageLoc = getUniformLoc( "image" );
    }

    override void uploadTexture ( Texture tex )
    {
        enforce!glActiveTexture( GL_TEXTURE0 );
        tex.bind();
        enforce!glUniform1i( _imageLoc, 0 );
    }
}
