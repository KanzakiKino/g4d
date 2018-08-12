// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
 +
 + This module declares utilities related to media file.
++/
module g4d.file.media;
import g4d.util.bitmap,
       g4d.exception;
import easyff.api;
import gl3n.linalg;
import std.conv,
       std.string;

///
class EasyFFException : G4dException
{
    ///
    this ( FFError err, string file = __FILE__, size_t line = __LINE__ )
    {
        super( err.to!string, file, line );
    }
}

/// A class that decodes media file.
class MediaFile
{
    protected FFReader* _file;
    protected FFStream* _video;

    ///
    this ( string path )
    {
        _file  = FFReader_new( path.toStringz );
        _video = FFReader_findVideoStream( _file );

        auto ret = FFReader_checkError( _file );
        if ( ret == FFError.NoError && _video ) {
            ret = FFStream_checkError( _video );
        }
        if ( ret != FFError.NoError ) {
            throw new EasyFFException( ret );
        }
    }

    ///
    ~this ()
    {
        dispose();
    }
    /// Releases all ffmpeg contexts.
    void dispose ()
    {
        if ( _file ) {
            FFReader_delete( &_file );
            _file = null;
        }
        _video = null;
    }

    /// Checks if the media file has video/image stream.
    const @property hasVideoStream () { return !!_video; }

    /// Decodes and returns next image as RGBA bitmap.
    BitmapRGBA decodeNextImage ()
    {
        if ( !hasVideoStream ) {
            throw new G4dException( "Video stream is not found." );
        }
        FFReader_decode( _file, _video );

        auto image = FFReader_convertFrameToImage( _file );
        if ( !image ) {
            throw new G4dException( "Converting frame to image is failed." );
        }
        scope(exit) FFImage_delete( &image );

        const w   = FFImage_getWidth ( image );
        const h   = FFImage_getHeight( image );
        auto  buf = FFImage_getBuffer( image );
        return new BitmapRGBA( vec2i(w,h), buf );
    }
}
