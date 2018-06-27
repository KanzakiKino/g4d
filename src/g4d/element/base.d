// Written under LGPL-3.0 in the D programming language.
// Copyright 2018 KanzakiKino
module g4d.element.base;
import g4d.shader.base;

// This is an interface of elements.
// Elements prepare a shader and draw something.
interface Element
{
    void clear ();
    void draw  ( Shader );
}
