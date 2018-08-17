// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module g4d.gl.array;

/// Creates positions array of rectangle vertexes.
float[4*4] createRectVertexPos ( float left, float top, float right, float bottom )
{
    return [
        left ,top   ,0f,1f,
        right,top   ,0f,1f,
        right,bottom,0f,1f,
        left ,bottom,0f,1f,
    ];
}

/// Creates uv array of rectangle vertexes.
float[4*2] createRectVertexUv ( float left, float top, float right, float bottom )
{
    return [
        left,top, right,top, right,bottom, left,bottom,
    ];
}
