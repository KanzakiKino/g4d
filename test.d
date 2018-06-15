// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
import g4d;
import std.math;

enum Text = "東條 英機（とうじょう ひでき、1884年（明治17年）7月30日（戸籍上は12月30日） - 1948年（昭和23年）12月23日）は、日本の陸軍軍人、政治家。階級位階勲等功級は陸軍大将従二位勲一等功二級。現在の百科事典や教科書等では新字体で東条 英機と表記されることが多い[注釈 3]。軍人および政治家として関東軍参謀長（第10代）、陸軍航空総監（初代）、陸軍大臣（第50-52代）、内閣総理大臣（第40代）、内務大臣（第64代）、外務大臣（第66代）、文部大臣（第53代）、商工大臣（第25代）、軍需大臣（初代）などを歴任した。"d;

void main ( string[] args )
{
    if ( args.length != 2 ) {
        throw new Exception( "Args are not enough." );
    }

    vec2 pos = vec2(0,0); bool clicking = false;
    auto win = new Window( vec2i(640,480), "hogehoge" );
    win.handler.onMouseMove = delegate void ( vec2 sz ) nothrow
    {
        pos = vec2( sz.x-320, -sz.y+240 );
    };
    win.handler.onMouseButton = delegate void ( MouseButton b, bool toggle )
    {
        if ( b == MouseButton.Left ) {
            clicking = toggle;
        }
    };

    auto font = new Font( "/usr/share/fonts/TTF/Ricty-Regular.ttf" );
    auto face = new FontFace( font, vec2i(16,16) );

    auto textElm          = new HTextElement;
    textElm.maxSize       = vec2(640,0);
    textElm.lineHeightMag = 3f;
    textElm.appendText( Text, face );

    auto bitmap  = new MediaFile(args[1]).decodeNextImage();
    auto texture = new Tex2D( bitmap );
    auto bmpSize = vec2(bitmap.width, bitmap.rows);
    auto texSize = vec2(texture.size);

    auto ngon = new RectElement;
    ngon.resize( vec2(400,400), vec2(bmpSize.x/texSize.x,bmpSize.y/texSize.y) );

    auto textShader       = new Alpha3DShader;
    textShader.projection = mat4.orthographic( -320f, 320f, 240f, -240f, short.min, short.max );

    auto rgbaShader       = new RGBA3DShader;
    rgbaShader.projection = mat4.orthographic( -320f, 320f, 240f, -240f, short.min, short.max );

    win.show();
    size_t frame = 0;
    while ( win.alive )
    {
        auto ease = frame%500/500f;

        win.pollEvents();
        win.resetFrame();

        rgbaShader.use();
        rgbaShader.translate = vec3(pos,400);
        rgbaShader.rotation  = vec3(ease*2*PI,ease*2*PI,ease*2*PI);
        rgbaShader.uploadTexture( texture );
        ngon.draw( rgbaShader );

        textShader.use();
        textShader.color     = clicking? vec4(1,0.3,0.3,1): vec4(1,1,1,1);
        textShader.translate = vec3(-320,240,0);
        textElm.draw( textShader );

        win.applyFrame();
        frame++;
    }
}
