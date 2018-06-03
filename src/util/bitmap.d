// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.util.bitmap;
import g4d.math.vector;
import std.algorithm,
       std.conv;
import core.stdc.string;

class Bitmap ( Type = ubyte, size_t LengthPerPixel = 4 )
{
    alias bitType        = Type;
    enum  lengthPerPixel = LengthPerPixel;

    protected Type[] _bits;
    @property bits () { return _bits; }
    @property ptr () { return _bits.ptr; }

    protected size_t _width, _rows;
    @property width () { return _width; }
    @property rows () { return _rows; }

    this ( Size sz )
    {
        resize( sz );
        clear();
    }
    this ( Size sz, Type* src, size_t srcByte )
    {
        this( sz );
        auto copyByte = min( srcByte, Type.sizeof*_bits.length );
        memcpy( ptr, src, copyByte );
    }
    this ( Size sz, Type[] src )
    {
        this( sz );
        _bits = src.dup;
    }

    protected void resize ( Size sz )
    {
        _width       = sz.x.to!uint;
        _rows        = sz.y.to!uint;
        _bits.length = width*rows*LengthPerPixel;
    }

    void clear ()
    {
        memset( ptr, 0, bits.length );
    }

    enum this_is_a_bitmap_class_of_g4d = true;
}

alias BitmapA    = Bitmap!(ubyte,1);
alias BitmapRGB  = Bitmap!(ubyte,3);
alias BitmapRGBA = Bitmap!(ubyte,4);

alias BitmapAf    = Bitmap!(float,1);
alias BitmapRGBf  = Bitmap!(float,3);
alias BitmapRGBAf = Bitmap!(float,4);

enum isBitmap(T) =
    __traits(hasMember,T,"this_is_a_bitmap_class_of_g4d");
