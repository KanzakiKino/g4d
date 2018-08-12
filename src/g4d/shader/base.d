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

    protected vec3 _transform;
    protected vec3 _rotation;
    protected vec3 _translate;
    protected mat4 _projection;

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
        initVertexShader();
        initFragShader();

        enforce!glGenVertexArrays( 1, &_vao );
        use();

        initVectors();
        _projection = mat4.identity;
        applyMatrix();
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
    const void use ( bool zbuffer = true )
    {
        enforce!glUseProgram( _program );
        enforce!glBindVertexArray( _vao );

        enforce!glEnable( GL_BLEND );
        enforce!glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );

        if ( zbuffer ) {
            enforce!glEnable( GL_DEPTH_TEST );
        } else {
            enforce!glDisable( GL_DEPTH_TEST );
        }
    }

    ///
    @property void matrix     ( mat4 );
    ///
    @property ref  transform  () { return _transform;  }
    ///
    @property ref  rotation   () { return _rotation;   }
    ///
    @property ref  translate  () { return _translate;  }
    ///
    @property ref  projection () { return _projection; }

    /// Sets transform, rotation and translate.
    void setVectors ( vec3 late, vec3 rota = vec3(0,0,0), vec3 form = vec3(1,1,1) )
    {
        transform = form;
        rotation  = rota;
        translate = late;
    }
    /// Sets all vectors to default value.
    void initVectors ()
    {
        setVectors( vec3(0,0,0) );
    }

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

    /// Sends the matrix to shader.
    void applyMatrix ()
    {
        auto result = _projection;
        if ( _translate != vec3(0,0,0) ) {
            result *= mat4.translation( _translate );
        }
        if ( _rotation != vec3(0,0,0) ) {
            result *= mat4.rotation( 1f, _rotation );
        }
        if ( _transform != vec3(1,1,1) ) {
            result *= mat4.scaling(
                    _transform.x, _transform.y, _transform.z );
        }
        matrix = result;
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
    protected Shader target;
    protected vec3   form, rota, late;
    protected mat4   proj;

    ///
    this ( Shader s ) {
        target = s;
        form = s.transform;
        rota = s.rotation;
        late = s.translate;
        proj = s.projection;
    }

    ///
    ~this ()
    {
        target.transform  = form;
        target.rotation   = rota;
        target.translate  = late;
        target.projection = proj;
    }
}
