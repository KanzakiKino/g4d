// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.util.bitmap;
import gl3n.linalg;
import std.algorithm,
       std.conv;
import core.stdc.stdlib,
       core.stdc.string;

class Bitmap ( Type = ubyte, size_t LengthPerPixel = 4 )
{
    alias bitType        = Type;
    enum  lengthPerPixel = LengthPerPixel;

    protected Type* _data;
    @property data () { return _data; }

    protected size_t _width, _rows;
    @property width () { return _width; }
    @property rows  () { return _rows; }

    @property size  ()
    {
        return vec2i( width.to!int, rows.to!int );
    }

    @property dataLength ()
    {
        return _width*_rows*LengthPerPixel;
    }
    @property dataByteSize ()
    {
        return dataLength * Type.sizeof;
    }

    this ( vec2i sz )
    {
        _data = null;
        resize( sz );
        clear();
    }
    this ( vec2i sz, Type* src )
    {
        this( sz );
        memcpy( data, src, dataByteSize );
    }
    this ( vec2i sz, Type[] src )
    {
        this( sz );
        memcpy( data, src.ptr, dataByteSize );
    }

    ~this ()
    {
        dispose();
    }
    void dispose ()
    {
        if ( _data ) {
            free( _data );
            _data = null;
        }
        _width = 0;
        _rows  = 0;
    }

    protected void resize ( vec2i sz )
    {
        dispose();
        _width = sz.x.to!uint;
        _rows  = sz.y.to!uint;
        _data  = cast(Type*)malloc( dataByteSize );
    }

    auto conservativeResize ( vec2i sz )
    {
        enum lpp = lengthPerPixel;

        auto srcw = width, srch = rows;
        auto src  = data;

        auto result = new typeof(this)( sz );
        auto dstw   = result.width, dsth = result.rows;
        auto dst    = result.data;

        size_t dstx = 0, dsty = 0,
               srci = 0, dsti = 0;

        for ( dsty = 0; dsty < dsth; dsty++ ) {
            for ( dstx = 0; dstx < dstw; dstx++ ) {
                if ( dstx >= srcw || dsty >= srch ) {
                    static foreach ( j; 0..lpp ) {
                        dst[dsti++] = 0;
                    }
                } else {
                    static foreach ( j; 0..lpp ) {
                        dst[dsti++] = src[srci++];
                    }
                }
            }
        }
        return result;
    }

    void overwrite ( vec2i offset, typeof(this) bmp )
    {
        enum lpp = lengthPerPixel;

        auto srcl = offset.x, srct = offset.y;
        auto srcr = srcl+bmp.width, srcb = srct+bmp.rows;
        auto src  = bmp.data;

        auto dstw = width, dsth = rows;
        auto dst  = data;

        assert( srcl >= 0 && srct >= 0 );
        assert( srcr <= dstw && srcb <= dsth );

        size_t dstx = srcl, dsty = srct,
               srci = 0, dsti = 0;

        for ( dsty = srct; dsty < srcb; dsty++ ) {
            dsti = (dsty*dstw + srcl)*lpp;
            for ( dstx = srcl; dstx < srcr; dstx++ ) {
                static foreach ( j; 0..lpp ) {
                    dst[dsti++] = src[srci++];
                }
            }
        }
    }

    void clear ()
    {
        memset( data, 0, dataByteSize );
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
