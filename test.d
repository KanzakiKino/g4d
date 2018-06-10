// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
import g4d;
import std.math;

void main ()
{
    auto win = new Window( vec2i(640,480), "hogehoge" );

    auto font = new Font( "/usr/share/fonts/TTF/Ricty-Regular.ttf" );
    auto face = new FontFace( font, vec2i(16,16) );

    auto textElm          = new HTextElement;
    textElm.maxSize       = vec2(640,0);
    textElm.lineHeightMag = 3f;
    textElm.appendText( "東條 英機（とうじょう ひでき、1884年（明治17年）7月30日（戸籍上は12月30日） - 1948年（昭和23年）12月23日）は、日本の陸軍軍人、政治家。階級位階勲等功級は陸軍大将従二位勲一等功二級。現在の百科事典や教科書等では新字体で東条 英機と表記されることが多い[注釈 3]。軍人および政治家として関東軍参謀長（第10代）、陸軍航空総監（初代）、陸軍大臣（第50-52代）、内閣総理大臣（第40代）、内務大臣（第64代）、外務大臣（第66代）、文部大臣（第53代）、商工大臣（第25代）、軍需大臣（初代）などを歴任した。"d, face );

    auto ngon = new RectElement;
    ngon.resize( vec2(300,200) );

    auto textShader       = new Alpha3DShader;
    textShader.color      = vec4(1,1,1,1);
    textShader.projection = mat4.orthographic( -320f, 320f, 240f, -240f, short.min, short.max );

    auto fillShader       = new Fill3DShader;
    fillShader.color      = vec4(0.5,0.5,0.5,0.5);
    fillShader.projection = mat4.orthographic( -320f, 320f, 240f, -240f, short.min, short.max );

    size_t frame = 0;
    while ( win.alive )
    {
        auto ease = frame%100/100f;

        win.pollEvents();
        win.resetFrame();

        fillShader.use();
        fillShader.translate = vec3(0,0,500);
        ngon.draw( fillShader );

        textShader.use();
        textShader.translate = vec3(-320,240,0);
        fillShader.rotation  = vec3(ease*2*PI,ease*2*PI,ease*2*PI);
        textElm.draw( textShader );

        win.applyFrame();
        frame++;
    }
}
