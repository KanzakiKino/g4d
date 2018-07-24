// Written without lICENSE in the D programming language.
// Copyright 2018 KanzakiKino
import g4d;
import std.algorithm,
       std.math,
       std.random;

class Game
{
    protected Window        _win;
    protected Alpha3DShader _shader;

    protected RectElement _elm;
    protected TextTexture _tex;

    this ()
    {
        _win    = new Window( vec2i(640,480), "HelloWorld - g4d", WindowHint.Resizable );
        _shader = new Alpha3DShader;

        auto face = new FontFace( new Font("/usr/share/fonts/TTF/Ricty-Regular.ttf"), vec2i(0,16) );

        _elm = new RectElement;
        _tex = new TextTexture( face, "hoge"d );
        _elm.resize( vec2(_tex.size), vec2(1,1) );

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
        while ( _win.alive ) {
            _win.pollEvents();
            _win.resetFrame();

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
