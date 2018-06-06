// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.shader.fragment.alphaf;

enum AlphafFragShaderSource = import("shader/fragment/alphaf.glsl");

template AlphafFragShader ()
{
    import g4d.gl.lib,
           g4d.gl.texture,
           g4d.math.vector;

    override const pure @property string fragSource ()
    {
        return AlphafFragShaderSource;
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
    override void uploadTexture ( Texture tex )
    {
        enforce!glActiveTexture( GL_TEXTURE0 );
        tex.bind();
        enforce!glUniform1i( _imageLoc, 0 );
    }
}
