// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.math.rational;
import std.traits;

N nextPower2 ( N ) ( N x )
    if ( isNumeric!N )
{
    N y = 1;
    while ( y <= x ) {
        y *= 2;
    }
    return y;
}
