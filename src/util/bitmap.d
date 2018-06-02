// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.util.bitmap;
import g4d.math.vector;
import std.conv;
import core.stdc.string;

class Bitmap ( uint BytePerPixel = 4 )
{
    protected ubyte[] _bits;
    @property bits () { return _bits; }
    @property ptr () { return _bits.ptr; }

    protected uint _width, _rows;
    @property width () { return _width; }
    @property rows () { return _rows; }

    this ( Size sz )
    {
        resize( sz );
        clear();
    }
    this ( Size sz, ubyte* src )
    {
        this( sz );
        memcpy( ptr, src, bits.length );
    }

    protected void resize ( Size sz )
    {
        _width       = sz.x.to!uint;
        _rows        = sz.y.to!uint;
        _bits.length = width*rows*BytePerPixel;
    }

    void clear ()
    {
        memset( ptr, 0, bits.length );
    }
}

alias BitmapA    = Bitmap!1;
alias BitmapRGB  = Bitmap!3;
alias BitmapRGBA = Bitmap!4;
