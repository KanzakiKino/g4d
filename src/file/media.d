// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.file.media;
import g4d.math.vector,
       g4d.util.bitmap,
       g4d.exception;
import easyff.api;
import std.conv,
       std.string;

class EasyFFException : G4dException
{
    this ( FFError err, string file = __FILE__, size_t line = __LINE__ )
    {
        super( err.to!string, file, line );
    }
}

class MediaFile
{
    protected FFReader* _file;
    protected FFStream* _video;

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
    ~this ()
    {
        FFReader_delete( &_file );
    }

    const @property bool hasVideoStream () { return !!_video; }

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

        auto w   = FFImage_getWidth ( image );
        auto h   = FFImage_getHeight( image );
        auto buf = FFImage_getBuffer( image );
        return new BitmapRGBA( vec2i(w,h), buf );
    }
}
