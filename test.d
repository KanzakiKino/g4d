// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
import g4d;

void main ()
{
    auto win = new Window( vec2i(640,480), "hogehoge" );

    auto font  = new Font( "/usr/share/fonts/TTF/Ricty-Regular.ttf" );
    auto face  = new FontFace( font, vec2i(16,16) );
    auto textElm = new HTextElement;
    textElm.appendText( "hoge"d, face );

    auto shader = new Alphaf3DShader;

    while ( win.alive )
    {
        win.pollEvents();
        win.resetFrame();

        shader.use();
        shader.color = vec4(1,1,1,1);
        textElm.draw( shader );

        // Draw something.

        win.applyFrame();
    }
}
