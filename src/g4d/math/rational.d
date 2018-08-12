// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module g4d.math.rational;
import std.traits;

/// Returns the number that is power of 2 and more than x.
N nextPower2 ( N ) ( inout N x )
    if ( isNumeric!N )
{
    N y = 1;
    while ( y <= x ) {
        y *= 2;
    }
    return y;
}
