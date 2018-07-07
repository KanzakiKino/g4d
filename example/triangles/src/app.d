import g4d;
import std.math,
       std.random,
       std.stdio;

class App
{
    protected Window       win;
    protected Fill3DShader shader;

    protected RegularNgonElement!3 triangle;
    protected vec3[50] pos;

    protected mat4 projection;
    protected vec3 rotation;

    this ()
    {
        win    = new Window( vec2i(640,480), "TRIANGLES", WindowHint.Visible );
        shader = new Fill3DShader;

        triangle = new RegularNgonElement!3;
        triangle.resize(50f);

        foreach ( ref v; pos ) {
            v = vec3(uniform(-320,320),uniform(-240,240),uniform(-1000,1000));
        }

        projection = mat4.orthographic(
                -320, 320, 240, -240, short.min, short.max );
        rotation = vec3(0,0,0);

        win.handler.onMouseMove = delegate ( vec2 pt )
        {
            const halfW = win.size.x, halfH = win.size.y;
            rotation.y = (pt.x/halfW-0.5)*PI*2;
            rotation.x = (pt.y/halfH-0.5)*PI*2;
        };
    }

    int exec ()
    {
        while ( win.alive )
        {
            win.pollEvents();
            win.resetFrame();

            shader.use();
            shader.color = vec4(1f,1f,1f,0.3f);
            shader.projection = projection *
                mat4.rotation( rotation.x, rotation.y, rotation.z );
            foreach ( v; pos ) {
                shader.setVectors( v );
                triangle.draw( shader );
            }

            win.applyFrame();
        }
        return 0;
    }
}

int main ()
{
    return (new App).exec();
}
