// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module g4d.util.bitmap;
import gl3n.linalg;
import std.algorithm,
       std.conv;
import core.stdc.stdlib,
       core.stdc.string;

/// A class of bitmap.
class Bitmap ( _Type = ubyte, size_t _LengthPerPixel = 4 )
{
    /// Type of the number that shows color.
    alias Type = _Type;

    /// Length to show the color of pixel.
    enum  LengthPerPixel = _LengthPerPixel;

    protected Type* _data;
    /// Readonly pointer to data.
    const @property data () { return _data; }

    protected size_t _width, _rows;
    /// Width of the bitmap.
    const @property width () { return _width; }
    /// Height of the bitmap.
    const @property rows  () { return _rows; }

    /// Size of the bitmap.
    const @property size  ()
    {
        return vec2i( width.to!int, rows.to!int );
    }

    /// Length of the bitmap data.
    const @property dataLength ()
    {
        return _width*_rows*LengthPerPixel;
    }
    /// Size of the bitmap data in byte.
    const @property dataByteSize ()
    {
        return dataLength * Type.sizeof;
    }

    ///
    this ( vec2i sz )
    {
        _data = null;
        resize( sz );
        clear();
    }
    ///
    this ( vec2i sz, Type* src )
    {
        this( sz );
        memcpy( _data, src, dataByteSize );
    }
    ///
    this ( vec2i sz, Type[] src )
    {
        this( sz );
        memcpy( _data, src.ptr, dataByteSize );
    }

    ///
    ~this ()
    {
        dispose();
    }
    /// Releases all memories.
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

    /// Creates resized bitmap with the same format.
    const auto conservativeResize ( vec2i sz )
    {
        enum lpp = LengthPerPixel;

        const srcw = width, srch = rows;
        const src  = data;

        auto  result = new Bitmap!(Type,lpp)( sz );
        const dstw   = result.width, dsth = result.rows;
        auto  dst    = result._data;

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

    /// Modifies a part of the bitmap.
    void overwrite ( vec2i offset, typeof(this) bmp )
    {
        enum lpp = LengthPerPixel;

        const srcl = offset.x, srct = offset.y;
        const srcr = srcl+bmp.width, srcb = srct+bmp.rows;
        const src  = bmp.data;

        const dstw = width, dsth = rows;
        auto  dst  = _data;

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

    /// Fills the bitmap data with 0.
    void clear ()
    {
        memset( _data, 0, dataByteSize );
    }

    /// To prove this is bitmap.
    enum this_is_a_bitmap_class_of_g4d = true;
}

///
alias BitmapA    = Bitmap!(ubyte,1);
///
alias BitmapRGB  = Bitmap!(ubyte,3);
///
alias BitmapRGBA = Bitmap!(ubyte,4);

///
alias BitmapAf    = Bitmap!(float,1);
///
alias BitmapRGBf  = Bitmap!(float,3);
///
alias BitmapRGBAf = Bitmap!(float,4);

/// Checks if T is bitmap.
enum isBitmap(T) =
    __traits(hasMember,T,"this_is_a_bitmap_class_of_g4d");
