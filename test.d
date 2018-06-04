// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
import g4d;

void main ()
{
    auto win = new Window( vec2i(640,480), "hogehoge" );

    auto font  = new Font( "/usr/share/fonts/TTF/Ricty-Regular.ttf" );
    auto face  = new FontFace( font, vec2i(16,16) );
    auto image = face.render('A').bmp;
    auto tex   = new Tex2D( image );

    auto vertexes = new ArrayBuffer(
            [0f,0f,0f,1f, 0.1f,0f,0f,1f, 0.1f,0.1f,0f,1f, 0f,0.1f,0f,1f] );
    auto uv = new ArrayBuffer( [0f,1f, 1f,1f, 1f,0f, 0f,0f] );

    auto shader = new RGBAf3DShader;

    while ( win.alive )
    {
        win.pollEvents();
        win.resetFrame();

        shader.use();
        shader.uploadPositionBuffer( vertexes );
        shader.uploadUvBuffer( uv );
        shader.uploadTexture( tex );
        shader.drawFan( 4 );

        // Draw something.

        win.applyFrame();
    }
}
