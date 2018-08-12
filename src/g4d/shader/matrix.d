// Written in the D programming language.
/++
 + Authors: KanzakiKino
 + Copyright: KanzakiKino 2018
 + License: LGPL-3.0
++/
module g4d.shader.matrix;
import gl3n.linalg;

/// A matrix data for the shader program.
struct ShaderMatrix
{
    protected mat4 _cache;
    protected bool _needRecalc = false;

    protected mat4 _projection = mat4.identity;

    protected vec3 _late = vec3(0,0,0);
    protected vec3 _rota = vec3(0,0,0);
    protected vec3 _form = vec3(1,1,1);

    /// Projection matrix.
    const @property projection () { return _projection; }

    ///
    @property void projection ( mat4 m )
    {
        _projection = m;
        _needRecalc = true;
    }

    /// Size of translation.
    const @property late () { return _late; }
    /// Amount of rotation.
    const @property rota () { return _rota; }
    /// Ratio of transformation.
    const @property form () { return _form; }

    ///
    @property void late ( vec3 v )
    {
        _late       = v;
        _needRecalc = true;
    }
    ///
    @property void rota ( vec3 v )
    {
        _rota       = v;
        _needRecalc = true;
    }
    ///
    @property void form ( vec3 v )
    {
        _form       = v;
        _needRecalc = true;
    }

    /// Cache of the calculation.
    /// If recalculating is needed, calculates before return.
    @property cache ()
    {
        if ( _needRecalc ) {
            calc();
        }
        return _cache;
    }

    /// Recalculates the matrix.
    void calc ()
    {
        _cache = mat4.scaling( _form.x, _form.y, _form.z );

        _cache.rotatex( _rota.x );
        _cache.rotatey( _rota.y );
        _cache.rotatez( _rota.z );

        _cache.translate( _late );

        _cache = _projection * _cache;

        _needRecalc = false;
    }
}
