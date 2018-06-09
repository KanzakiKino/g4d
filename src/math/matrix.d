// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.math.matrix;
import std.conv,
       std.math,
       std.traits;

unittest
{
    auto identity = mat4.identity;
    assert( (identity*mat1x4([1,2,3,1])).aa == 1f );

    auto translate = mat4.translate(10,10,0);
    assert( (translate*mat1x4([1,2,3,1])).aa == 11f );
}

// This is a struct of matrix.
struct Matrix ( Type, ubyte DimX, ubyte DimY )
    if ( isNumeric!Type && 0 < DimX && 0 < DimY )
{
    alias type = Type;
    enum  dimX = DimX;
    enum  dimY = DimY;

    static @property isSquare () { return DimX == DimY; }

    static if ( isSquare )
    {
        static if ( DimX == 4 )
        {
            static translate ( Type x, Type y, Type z )
            {
                return typeof(this)([
                    1, 0, 0, x,
                    0, 1, 0, y,
                    0, 0, 1, z,
                    0, 0, 0, 1,
                ]);
            }
            static transform ( Type x, Type y, Type z )
            {
                return typeof(this)([
                    x, 0, 0, 0,
                    0, y, 0, 0,
                    0, 0, z, 0,
                    0, 0, 0, 1,
                ]);
            }
            static rotation ( Type x, Type y, Type z )
            {
                auto xmat = typeof(this)([
                    1,      0,       0, 0,
                    0, cos(x), -sin(x), 0,
                    0, sin(x),  cos(x), 0,
                    0,      0,       0, 1,
                ]);
                auto ymat = typeof(this)([
                     cos(y), 0, sin(y), 0,
                          0, 1,      0, 0,
                    -sin(y), 0, cos(y), 0,
                          0, 0,      0, 1,
                ]);
                auto zmat = typeof(this)([
                     cos(z), -sin(z), 0, 0,
                     sin(z),  cos(z), 0, 0,
                          0,       0, 1, 0,
                          0,       0, 0, 1,
                ]);
                return xmat*ymat*zmat;
            }
        }
        static @property identity ()
        {
            auto result = typeof(this)( [] );
            static foreach ( i; 0..DimX ) {
                result.get!(i,i) = 1;
            }
            return result;
        }
    }

    protected Type[DimY][DimX] _scalars;
    const @property scalars () { return _scalars; }
    const @property ptr () { return &_scalars[0][0]; }

    this ( Type[] mat )
    {
        static foreach ( i; 0..(DimX*DimY) ) {
            if ( mat.length > i ) {
                _scalars[i%DimX][i/DimX] = mat[i];
            } else {
                _scalars[i%DimX][i/DimX] = 0;
            }
        }
    }
    this () @disable;

    protected ref get ( ubyte x, ubyte y ) ()
        if ( x < DimX && y < DimY )
    {
        return _scalars[x][y];
    }

    static if ( DimX >= 1 )
    {
        static if ( DimY >= 1 ) alias aa = get!(0,0);
        static if ( DimY >= 2 ) alias ab = get!(0,1);
        static if ( DimY >= 3 ) alias ac = get!(0,2);
        static if ( DimY >= 4 ) alias ad = get!(0,3);
    }
    static if ( DimX >= 2 )
    {
        static if ( DimY >= 1 ) alias ba = get!(1,0);
        static if ( DimY >= 2 ) alias bb = get!(1,1);
        static if ( DimY >= 3 ) alias bc = get!(1,2);
        static if ( DimY >= 4 ) alias bd = get!(1,3);
    }
    static if ( DimX >= 3 )
    {
        static if ( DimY >= 1 ) alias ca = get!(2,0);
        static if ( DimY >= 2 ) alias cb = get!(2,1);
        static if ( DimY >= 3 ) alias cc = get!(2,2);
        static if ( DimY >= 4 ) alias cd = get!(2,3);
    }
    static if ( DimX >= 4 )
    {
        static if ( DimY >= 1 ) alias da = get!(3,0);
        static if ( DimY >= 2 ) alias db = get!(3,1);
        static if ( DimY >= 3 ) alias dc = get!(3,2);
        static if ( DimY >= 4 ) alias dd = get!(3,3);
    }

    string toString ()
    {
        return scalars.to!string;
    }

    auto opBinary ( string op, M ) ( M rhs )
        if ( op == "*" && isMatrix!M && DimX == M.dimY )
    {
        alias Result = Matrix!( float, rhs.dimX, DimY );
        auto  result = Result( [] );

        static foreach ( lhsY; 0..DimY ) {
            static foreach ( lhsX; 0..DimX ) {
                static foreach ( rhsX; 0..(M.dimX) ) {
                    result.get!(rhsX,lhsY) += get!(lhsX,lhsY) * rhs.get!(rhsX,lhsX);
                }
            }
        }
        return result;
    }

    enum this_is_a_matrix_struct_of_g4d = true;
}

alias mat1x4 = Matrix!(float,1,4);
alias mat4   = Matrix!(float,4,4);

// A template that checks whether T is matrix;
enum isMatrix(T) =
    __traits(hasMember,T,"this_is_a_matrix_struct_of_g4d");
