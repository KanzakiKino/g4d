// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
import g4d;

void main ()
{
    auto win = new Window( vec2i(640,480), "hogehoge" );

    float[] pixs = [
        0f,0f,0f,0f, 1f,1f,1f,1f, 0f,0f,0f,0f, 1f,1f,1f,1f, 0f,0f,0f,0f,
        1f,1f,1f,1f, 1f,1f,1f,1f, 1f,1f,1f,1f, 1f,1f,1f,1f, 1f,1f,1f,1f,
        0f,0f,0f,0f, 1f,1f,1f,1f, 0f,0f,0f,0f, 1f,1f,1f,1f, 0f,0f,0f,0f,
        1f,1f,1f,1f, 1f,1f,1f,1f, 1f,1f,1f,1f, 1f,1f,1f,1f, 1f,1f,1f,1f,
        0f,0f,0f,0f, 1f,0f,0f,1f, 0f,0f,0f,0f, 1f,1f,1f,1f, 0f,0f,0f,0f,
    ]; // There will be a red pixel at bottom of the texture.
    auto image = new BitmapRGBAf( vec2i(5,5), pixs );
    auto tex = new Tex2D( image );

    auto image2 = new BitmapAf( vec2i(1,1), [0f] );
    tex.overwrite( image2, vec2i(1,1) );

    auto vertexes = new ArrayBuffer(
            [0f,0f,0f,1f, 0.3f,0f,0f,1f, 0.3f,0.3f,0f,1f, 0f,0.3f,0f,1f] );
    auto rate = 5f/8;
    auto uv = new ArrayBuffer( [0f,rate, rate,rate, rate,0f, 0f,0f] );

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
