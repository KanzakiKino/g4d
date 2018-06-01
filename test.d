// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
import g4d;

void main ()
{
    auto win = new Window( 640, 480, "hogehoge" );
    while ( win.alive )
    {
        win.pollEvents();
        win.clearDisplay();
        win.applyDisplay();
    }
}
