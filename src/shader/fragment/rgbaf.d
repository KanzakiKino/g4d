// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.shader.fragment.rgbaf;

enum RGBAfFragShaderSource = import("shader/fragment/rgbaf.glsl");

template RGBAfFragShader ()
{
    import g4d.gl.lib,
           g4d.gl.texture,
           g4d.math.vector;

    override const pure @property string fragSource ()
    {
        return RGBAfFragShaderSource;
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
