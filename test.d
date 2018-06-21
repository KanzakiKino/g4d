// Written without lICENSE in the D programming language.
// Copyright 2018 KanzakiKino
import g4d;
import std.algorithm,
       std.math,
       std.random;

class Game
{
    enum PolyCount = 500;

    protected Window       _win;
    protected Fill3DShader _shader;

    protected RegularNgonBorderElement!3 _drawer;

    struct Poly
    {
        float size;
        vec3 pos;
        vec3 speed;
        vec3 rota;
        vec3 rotaSpeed;
        vec4 color;
    }
    protected Poly[] _polys;

    this ()
    {
        _win    = new Window( vec2i(640,480), "HelloWorld - g4d", WindowHint.Resizable );
        _shader = new Fill3DShader;
        _drawer = new RegularNgonBorderElement!3;

        _win.handler.onFbResize = delegate ( vec2i sz )
        {
            resizeViewport( sz );
        };
        resizeViewport( _win.size );

        _win.handler.onMouseButton = delegate ( MouseButton btn, bool press )
        {
            if ( !press && btn == MouseButton.Right ) {
                createPolys();
            }
        };
        createPolys();
    }

    protected void resizeViewport ( vec2i sz )
    {
        _win.clip( vec2i(0,0), sz );

        auto halfW = sz.x/2;
        auto halfH = sz.y/2;
        _shader.projection = mat4.orthographic( -halfW, halfW, halfH, -halfH, short.min, short.max );
    }

    protected void createPolys ()
    {
        auto sz = _win.size;
        auto halfW = sz.x/2f;
        auto halfH = sz.y/2f;

        auto rndX () { return uniform( -halfW, halfW ); }
        auto rndY () { return uniform( -halfH, halfH ); }
        auto rndZ () { return uniform( short.min, short.max ); }
        auto rndCol () { return uniform(0f,1f); }

        _polys = [];
        for ( size_t i = 0; i < PolyCount; i++ ) {
            Poly poly;
            poly.size      = uniform( 10f, 100f );
            poly.pos       = vec3( rndX, rndY, rndZ );
            poly.speed     = vec3( rndZ%10, rndZ%10, rndZ%10 );
            poly.rota      = vec3( rndZ%PI, rndZ%PI, rndZ%PI );
            poly.rotaSpeed = vec3( rndCol%0.1, rndCol%0.1, rndCol%0.1 );
            poly.color     = vec4( rndCol, rndCol, rndCol, 1f );
            _polys ~= poly;
        }
    }

    protected void updatePolys ()
    {
        auto sz = _win.size;
        auto halfW = sz.x/2f;
        auto halfH = sz.y/2f;

        foreach ( ref poly; _polys ) {
            poly.pos += poly.speed;
            if ( poly.pos.x > halfW || poly.pos.x < -halfW ) {
                poly.speed.x *= -1;
            }
            if ( poly.pos.y > halfH || poly.pos.y < -halfH ) {
                poly.speed.y *= -1;
            }
            poly.pos.x = min(halfW, max(-halfW, poly.pos.x));
            poly.pos.y = min(halfH, max(-halfH, poly.pos.y));

            poly.rota += poly.rotaSpeed;
        }
    }

    void exec ()
    {
        _win.show();
        _drawer.resize( 100, 10 );
        while ( _win.alive ) {
            _win.pollEvents();
            _win.resetFrame();

            updatePolys();

            _shader.use();
            _shader.translate = vec3(0,0,0);
            _shader.rotation  = vec3(0,0,0);
            _shader.color     = vec4(1f,1f,1f,1f);
            _drawer.draw( _shader );

            _win.applyFrame();
        }
    }
}

void main ( string[] args )
{
    (new Game).exec();
}
