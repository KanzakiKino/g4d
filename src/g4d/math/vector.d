// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.math.vector;
import g4d.math.matrix;
import std.conv,
       std.traits;

unittest
{
    import std.algorithm;
    auto v2 = Vector!(int,2)( 1, 2 );
    auto v3 = Vector!(float,3)( v2, 0 );
    assert( equal( v3.scalars.dup, [1,2,0] ) );

    v3 += v2;
    assert( equal(v3.scalars.dup, [2,4,0]) );
    v3 *= 5;
    assert( equal(v3.scalars.dup, [10,20,0]) );
    assert( equal((v3-v2).scalars.dup, [9,18,0]) );

    v3.z = 5;
    assert( equal(v3.scalars.dup, [10,20,5]) );

    assert( v3.toMatrix.aa == 10 );
    assert( equal(vec4(mat1x4([1,2,3,4])).scalars.dup, [1,2,3,4]) );

    assert( vec2(10f,10f)/2 == vec2(5f,5f) );

    v2 -= vec2i(1,1);

    assert( !isVector!int );
}

// This is a struct of vector.
struct Vector ( Type, ubyte Dimension )
    if ( isNumeric!Type && Dimension > 0 && Dimension <= 4 )
{
    enum  dimension = Dimension;
    alias type      = Type;

    protected Type[Dimension] _scalars;
    const @property scalars () { return _scalars; }
    const @property ptr () { return _scalars.ptr; }

    this ( Args... ) ( Args args )
    {
        init( args );
    }

    protected void init ( Args... ) ( Args args )
    {
        enum Msg {
            TooManyScalar   = "Vector was initialized with too many scalars.",
            UnsupportScalar = "Vector was initialized with unsupported scalar type."
        }
        size_t index = 0;
        static foreach ( arg; args )
        {
            assert( index < Dimension, Msg.TooManyScalar );

            static if ( isNumeric!(typeof(arg)) ) {
                _scalars[index++] = arg.to!Type;

            } else static if ( isVector!(typeof(arg)) ) {
                assert( index+arg.dimension-1 < Dimension, Msg.TooManyScalar );
                foreach ( scalar; arg.scalars ) {
                    _scalars[index++] = scalar.to!Type;
                }

            } else static if ( isMatrix!(typeof(arg)) && arg.dimX == 1 && arg.dimY == Dimension ) {
                assert( index == 0, Msg.TooManyScalar );
                static foreach ( i; 0..Dimension ) {
                    _scalars[index++] = arg.scalars[0][i];
                }

            } else {
                static assert( false, Msg.UnsupportScalar );
            }
        }
    }

    protected ref get ( uint D = 0 ) ()
    {
        enum Msg = "Dimension is out of range.";
        static assert( D > 0 && D <= Dimension, Msg );
        return _scalars[D-1];
    }

    static if ( Dimension >= 4 ) {
        alias w = get!4, a = get!4;
    }
    static if ( Dimension >= 3 ) {
        alias z = get!3, r = get!1, g = get!2, b = get!3;
    }
    static if ( Dimension >= 2 ) {
        alias y = get!2;
    }
    static if ( Dimension >= 1 ) {
        alias x = get!1;
    }

    string toString ()
    {
        return scalars.to!string;
    }
    auto toMatrix ()
    {
        return Matrix!(Type,1,Dimension)( _scalars );
    }

    protected void plus ( T ) ( T rhs )
        if ( isVector!T )
    {
        static assert( Dimension >= rhs.dimension,
                "RHS' dimension is over LHS'." );
        foreach ( i,scalar; rhs.scalars ) {
            if ( i >= Dimension ) {
                break;
            }
            _scalars[i] += scalar;
        }
    }
    protected void multiple ( T ) ( T rhs )
        if ( isNumeric!T )
    {
        foreach ( ref scalar; _scalars ) {
            scalar *= rhs;
        }
    }

    void opOpAssign ( string op, T ) ( T rhs )
    {
        static if ( op == "+" ) {
            plus( rhs );
        } else static if ( op == "-" ) {
            plus( rhs*-1 );
        } else static if ( op == "*" ) {
            multiple( rhs );
        } else static if ( op == "/" ) {
            multiple( 1f/rhs );
        } else {
            static assert( false, "Operated with unsupported type." );
        }
    }
    auto opBinary ( string op, T ) ( T rhs )
    {
        static if ( isVector!(typeof(rhs)) ) {
            static if ( rhs.dimension > Dimension ) {
                auto result = rhs;
            } else {
                auto result = this;
            }
        } else {
            auto result = this;
        }

        static if ( op == "+" ) {
            result.plus( rhs );
        } else static if ( op == "-" ) {
            result.plus( rhs*-1 );
        } else static if ( op == "*" ) {
            result.multiple( rhs );
        } else static if ( op == "/" ) {
            result.multiple( 1f/rhs );
        } else {
            static assert( false, "Operated with unsupported type." );
        }
        return result;
    }

    enum this_is_a_vector_struct_of_g4d = true;
}

alias vec2i = Vector!(int,2);
alias vec3i = Vector!(int,3);
alias vec4i = Vector!(int,4);
alias vec2  = Vector!(float,2);
alias vec3  = Vector!(float,3);
alias vec4  = Vector!(float,4);

// A template that checks whether T is vector.
enum isVector(T) =
    __traits(hasMember,T,"this_is_a_vector_struct_of_g4d");
