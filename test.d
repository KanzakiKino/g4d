// Written without lICENSE in the D programming language.
// Copyright 2018 KanzakiKino
import g4d;

class Game
{
    protected Window        _win;
    protected Alpha3DShader _shader;

    protected HTextElement _elm;
    protected FontFace     _face;

    this ()
    {
        _win    = new Window( vec2i(640,480), "HelloWorld - g4d", WindowHint.Resizable );
        _shader = new Alpha3DShader;

        _elm  = new HTextElement;
        _face = new FontFace( new Font("/usr/share/fonts/TTF/Ricty-Regular.ttf"), vec2i(0,16) );

        _win.handler.onWindowResize = delegate ( vec2i sz )
        {
            resizeViewport( sz );
        };
        resizeViewport( _win.size );
    }

    protected void resizeViewport ( vec2i sz )
    {
        _win.clip( vec2i(0,0), sz );

        auto halfW = sz.x/2;
        auto halfH = sz.y/2;
        _shader.projection = mat4.orthographic( -halfW, halfW, halfH, -halfH, short.min, short.max );
    }

    void exec ()
    {
        _win.show();
        ulong frame = 0;
        while ( _win.alive ) {
            _win.pollEvents();
            _win.resetFrame();

            if ( frame%150 == 0 ) {
                _elm.loadText( _face, "KEISUKE HONDA"d );
            } else if ( frame%50 == 0 ) {
                _elm.loadText( _face, "HONDA"d );
            } else if ( frame%30 == 0 ) {
                _elm.loadText( _face, "KEISUKE"d );
            }
            frame++;

            _shader.use();
            _shader.initVectors();
            _shader.color = vec4(1,1,1,1);
            _elm.draw( _shader );

            _win.applyFrame();
        }
    }
}

void main ( string[] args )
{
    (new Game).exec();
}
