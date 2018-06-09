// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
import g4d;

void main ()
{
    auto win = new Window( vec2i(640,480), "hogehoge" );

    auto font = new Font( "/usr/share/fonts/TTF/Ricty-Regular.ttf" );
    auto face = new FontFace( font, vec2i(16,16) );

    auto textElm          = new HTextElement;
    textElm.maxSize       = vec2(640,0);
    textElm.lineHeightMag = 3f;
    textElm.appendText( "東條 英機（とうじょう ひでき、1884年（明治17年）7月30日（戸籍上は12月30日） - 1948年（昭和23年）12月23日）は、日本の陸軍軍人、政治家。階級位階勲等功級は陸軍大将従二位勲一等功二級。現在の百科事典や教科書等では新字体で東条 英機と表記されることが多い[注釈 3]。軍人および政治家として関東軍参謀長（第10代）、陸軍航空総監（初代）、陸軍大臣（第50-52代）、内閣総理大臣（第40代）、内務大臣（第64代）、外務大臣（第66代）、文部大臣（第53代）、商工大臣（第25代）、軍需大臣（初代）などを歴任した。"d, face );

    auto shader       = new Alphaf3DShader;
    shader.color      = vec4(1,0.5,1,0.7);
    shader.rotation   = vec3(0f,0f,0f);
    shader.projection = mat4.transform( 1f/320f, 1f/240f, 1f );

    while ( win.alive )
    {
        win.pollEvents();
        win.resetFrame();

        shader.use();
        shader.transform  = vec3(1,1,1);
        shader.translate  = vec3(-320,240,0);
        textElm.draw( shader );

        win.applyFrame();
    }
}
