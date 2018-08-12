// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
import g4d;
import std.digest.sha,
       std.conv;

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

        _face = new FontFace( new Font("/usr/share/fonts/TTF/Ricty-Regular.ttf"), vec2i(0,16) );
        _text = new HTextElement;

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

    protected int seed;
    protected dstring getText ()
    {
        char alphabet = 'a'+(seed++%26);
        return (alphabet~"").sha1Of.toHexString.to!dstring;
    }

    void exec ()
    {
        _win.show();
        ulong frame = 0;
        while ( _win.alive ) {
            _win.pollEvents();
            _win.resetFrame();

            _text.loadText( _face, getText() );

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
