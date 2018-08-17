// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module g4d.shader.base;
import g4d.gl.buffer,
       g4d.gl.lib,
       g4d.gl.texture,
       g4d.gl.type,
       g4d.shader.matrix,
       g4d.exception;
import gl3n.linalg;
import std.conv,
       std.string;

/// A baseclass of shader.
abstract class Shader
{
    protected static GLuint compileShader ( GLenum shaderType, string src )
    {
        const csrc = src.toStringz;

        GLuint shader = enforce!glCreateShader( shaderType );
        enforce!glShaderSource( shader, 1, &csrc, null );
        enforce!glCompileShader( shader );

        GLint status;
        enforce!glGetShaderiv( shader, GL_COMPILE_STATUS, &status );
        if ( status == GL_FALSE ) {
            ShaderException.throwShaderLog( shader );
        }
        return shader;
    }

    /// Invalid shader program id.
    enum NullId = 0;

    protected GLuint _vertex;
    protected GLuint _fragment;
    protected GLuint _program;
    protected GLuint _vao;

    protected ShaderMatrix _matrix;
    /// Data of translation, rotation and transformation.
    @property ref matrix () { return _matrix; }

    /// GLSL source code of vertex shader.
    const pure @property string vertexSource ();
    /// GLSL source code of fragment shader.
    const pure @property string fragSource ();

    ///
    this ()
    {
        _vertex = compileShader( GL_VERTEX_SHADER, vertexSource );
        scope(failure) enforce!glDeleteShader( _vertex );

        _fragment = compileShader( GL_FRAGMENT_SHADER, fragSource );
        scope(failure) enforce!glDeleteShader( _fragment );

        _program = enforce!glCreateProgram();
        scope(failure) enforce!glDeleteProgram( _program );
        enforce!glAttachShader( _program, _vertex );
        enforce!glAttachShader( _program, _fragment );
        enforce!glLinkProgram( _program );

        GLint status;
        enforce!glGetProgramiv( _program, GL_LINK_STATUS, &status );
        if ( status == GL_FALSE ) {
            ShaderException.throwProgramLog( _program );
        }
        enforce!glGenVertexArrays( 1, &_vao );
        use();

        initVertexShader();
        initFragShader();
    }

    ///
    ~this ()
    {
        dispose();
    }
    /// Checks if the shader is disposed.
    const @property disposed ()
    {
        return _program == NullId;
    }
    /// Deletes all programs and shaders.
    void dispose ()
    {
        if ( !disposed ) {
            enforce!glDeleteVertexArrays( 1, &_vao );
            enforce!glDeleteProgram( _program );
            enforce!glDeleteShader( _vertex );
            enforce!glDeleteShader( _fragment );
        }
        _program = NullId;
    }

    protected GLint getUniformLoc ( string name )
    {
        return enforce!glGetUniformLocation( _program, name.toStringz );
    }
    protected GLint getAttribLoc ( string name )
    {
        return enforce!glGetAttribLocation( _program, name.toStringz );
    }

    protected void initVertexShader ();
    protected void initFragShader ();

    /// Checks the shader supports texture.
    const @property bool textureSupport () { return false; }

    /// Sets the shader binded.
    const void use ()
    {
        enforce!glUseProgram( _program );
        enforce!glBindVertexArray( _vao );
    }

    /// Uploads matrix.
    void uploadMatrix ( mat4 );

    /// Uploads position buffer.
    void uploadPositionBuffer ( in ArrayBuffer );

    /// Uploads uv buffer.
    void uploadUvBuffer ( in ArrayBuffer )
    {
        throw new ShaderException( "This shader doesn't support texture." );
    }
    /// Uploads texture.
    void uploadTexture ( in Texture )
    {
        throw new ShaderException( "This shader doesn't support texture." );
    }

    /// Applies the matrix.
    void applyMatrix ()
    {
        uploadMatrix( _matrix.cache );
    }

    /// Calls glDrawArrays with GL_TRIANGLE_FAN.
    void drawFan ( size_t polyCnt )
    {
        enforce!glDrawArrays( GL_TRIANGLE_FAN, 0, polyCnt.to!int );
    }
    /// Calls glDrawArrays with GL_TRIANGLE_STRIP.
    void drawStrip ( size_t polyCnt )
    {
        enforce!glDrawArrays( GL_TRIANGLE_STRIP, 0, polyCnt.to!int );
    }

    /// Calls glDrawElements with GL_TRIANGLE_FAN.
    void drawElementsFan ( ElementArrayBuffer buf, size_t polyCnt )
    {
        buf.bind();
        enum type = toGLType!(buf.BufferType);
        enforce!glDrawElements( GL_TRIANGLE_FAN, polyCnt.to!int, type, null );
    }
    /// Calls glDrawElements with GL_TRIANGLE_STRIP.
    void drawElementsStrip ( ElementArrayBuffer buf, size_t polyCnt )
    {
        buf.bind();
        enum type = toGLType!(buf.BufferType);
        enforce!glDrawElements( GL_TRIANGLE_STRIP, polyCnt.to!int, type, null );
    }
}

/// An exception type used in shader modules.
class ShaderException : G4dException
{
    /// Checks if the shader throwed errors, and throws it.
    static void throwShaderLog ( GLuint shader, string file = __FILE__, size_t line = __LINE__ )
    {
        GLint logLength = 0;
        enforce!glGetShaderiv( shader, GL_INFO_LOG_LENGTH, &logLength );

        auto log = new char[logLength];
        enforce!glGetShaderInfoLog( shader, logLength, &logLength, log.ptr );
        throw new ShaderException( "ShaderLog: "~log.to!string, file, line );
    }

    /// Checks if the shader program throwed errors, and throws it.
    static void throwProgramLog ( GLuint program, string file = __FILE__, size_t line = __LINE__ )
    {
        GLint logLength = 0;
        enforce!glGetProgramiv( program, GL_INFO_LOG_LENGTH, &logLength );

        auto log = new char[logLength];
        enforce!glGetProgramInfoLog( program, logLength, &logLength, log.ptr );
        throw new ShaderException( "ProgramLog: "~log.to!string, file, line );
    }

    ///
    this ( string msg, string file = __FILE__, size_t line = __LINE__ )
    {
        super( msg, file, line );
    }
}

/// A struct that saves status of the shader,
/// and restores the shader using saved status.
struct ShaderStateSaver
{
    protected Shader       _target;
    protected ShaderMatrix _backup;

    ///
    this ( Shader s ) {
        _target = s;
        _backup = s.matrix;
    }

    ///
    ~this ()
    {
        _target.matrix = _backup;
    }
}
