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

    protected RegularNgonBorderElement!3 _rc;

    protected HTextElement _text;
    protected FontFace     _face;

    this ()
    {
        _win    = new Window( vec2i(640,480), "HelloWorld - g4d", WindowHint.Resizable );
        _textShader = new Alpha3DShader;
        _rectShader = new Fill3DShader;

        _rc = new RegularNgonBorderElement!3;
        _rc.resize( 100f, 50f );

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
        auto proj  = mat4.orthographic( -halfW, halfW, -halfH, halfH, short.min, short.max );

        _textShader.matrix.projection = proj;
        _rectShader.matrix.projection = proj;
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

        StencilBuffer.enable();
        DepthBuffer  .enable();
        ColorBuffer  .enableBlend();

        while ( _win.alive ) {
            _win.pollEvents();
            _win.resetFrame();

            ColorBuffer.clear();
            DepthBuffer.clear();

//            StencilBuffer.clear( 1 );
//            StencilBuffer.startModify( 0 );
//            ColorBuffer.mask( false, false, false, false );
//            DepthBuffer.mask( false );

            _text.loadText( _face, getText() );

            _textShader.use();
            _textShader.matrix.late = vec3(0,0,0);
            _textShader.color = vec4(1,1,1,1);
            _text.draw( _textShader );

//            StencilBuffer.startTest();
//            ColorBuffer.mask( true, true, true, true );
//            DepthBuffer.mask( true );
//
//            _rectShader.use();
//            _rectShader.matrix.late = vec3(50,0,0);
//            _rectShader.color = vec4(1,0,0,1);
//            _rc.draw( _rectShader );

            _win.applyFrame();
        }
    }
}

void main ( string[] args )
{
    (new Game).exec();
}
