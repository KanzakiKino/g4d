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
        0f,0f,0f,0f, 1f,1f,1f,1f, 0f,0f,0f,0f, 1f,1f,1f,1f, 0f,0f,0f,0f,
    ];
    auto image = new BitmapRGBAf( vec2i(5,5), pixs );
    auto tex = new Tex2D( image );

    while ( win.alive )
    {
        win.pollEvents();
        win.resetFrame();

        // Draw something.

        win.applyFrame();
    }
}
