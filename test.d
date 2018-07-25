// Written without lICENSE in the D programming language.
// Copyright 2018 KanzakiKino
import g4d;

class Game
{
    protected Window        _win;
    protected Alpha3DShader _textShader;
    protected Fill3DShader  _rectShader;

    protected RectElement _rc;

    protected HTextElement _text;
    protected FontFace     _face;

    this ()
    {
        _win    = new Window( vec2i(640,480), "HelloWorld - g4d", WindowHint.Resizable );
        _textShader = new Alpha3DShader;
        _rectShader = new Fill3DShader;

        _rc = new RectElement;
        _rc.resize( vec2(50,100) );

        _text = new HTextElement;
        _face = new FontFace( new Font("/usr/share/fonts/TTF/Ricty-Regular.ttf"), vec2i(0,16) );

        _win.handler.onWindowResize = delegate ( vec2i sz )
        {
            resizeViewport( sz );
        };
        resizeViewport( _win.size );
    }

    protected void resizeViewport ( vec2i sz )
    {
        auto halfW = sz.x/2;
        auto halfH = sz.y/2;
        auto proj  = mat4.orthographic( -halfW, halfW, halfH, -halfH, short.min, short.max );

        _textShader.projection = proj;
        _rectShader.projection = proj;
    }

    void exec ()
    {
        _win.show();
        ulong frame = 0;
        while ( _win.alive ) {
            _win.pollEvents();
            _win.resetFrame();

            if ( frame%150 == 0 ) {
                _text.loadText( _face, "KEISUKE HONDA"d );
            } else if ( frame%50 == 0 ) {
                _text.loadText( _face, "HONDA"d );
            } else if ( frame%30 == 0 ) {
                _text.loadText( _face, "KEISUKE"d );
            }
            frame++;

            Stencil.resetBuffer( false, true );
            _rectShader.use();
            _rectShader.initVectors();
            _rectShader.color = vec4(1,1,1,0.5);
            _rc.draw( _rectShader );
            Stencil.applyBuffer();

            _textShader.use();
            _textShader.initVectors();
            _textShader.color = vec4(1,1,1,1);
            _text.draw( _textShader );

            _win.applyFrame();
        }
    }
}

void main ( string[] args )
{
    (new Game).exec();
}
