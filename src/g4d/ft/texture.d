// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module g4d.ft.texture;
import g4d.ft.font,
       g4d.ft.lib,
       g4d.gl.buffer,
       g4d.gl.texture,
       g4d.math.rational,
       g4d.util.bitmap;
import gl3n.linalg;
import std.algorithm,
       std.array,
       std.conv;

/// A texture of text.
class TextTexture : Tex2D
{
    /// A metrics data of characters.
    struct Metrics
    {
        /// Size in pixel.
        vec2i size;
        /// UV buffer.
        ArrayBuffer uv;

        /// Width of collision.
        ulong horiAdvance;
        /// Size of moving from origin.
        vec2i horiBearing;
    }

    protected Metrics[dchar] _chars;
    /// Metrics data of characters drawn this texture.
    const @property chars () { return _chars; }

    /// Creates text texture from FontFace and text.
    this ( FontFace face, dstring text )
    {
        text = text.uniq.array;
        super( renderBitmap( face, text ), true );
    }

    protected BitmapA renderBitmap ( FontFace face, dstring text )
    {
        auto size = vec2i( face.size );
        size.x   *= text.length;

        auto result = new BitmapA( size );

        size.x = size.x.nextPower2;
        size.y = size.y.nextPower2;

        Glyph   g;
        Metrics m;
        int     pos = 0;
        float   left, top, right, bottom;

        foreach ( c; text ) {
            g = face.render( c );

            result.overwrite( vec2i(pos,0), g.bmp );

            m.size        = g.bmp.size;
            m.horiBearing = g.bearing;
            m.horiAdvance = g.advance;

            left   = pos*1f / size.x;
            top    = 0;
            pos   += m.size.x;
            right  = pos*1f / size.x;
            bottom = m.size.y*1f / size.y;

            m.uv = new ArrayBuffer([
                left,top, right,top, right,bottom, left,bottom,
            ]);

            _chars[c] = m;
            g.bmp.dispose();
        }
        return result;
    }
}
