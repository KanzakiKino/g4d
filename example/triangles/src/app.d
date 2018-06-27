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

    this ()
    {
        win    = new Window( vec2i(640,480), "TRIANGLES", WindowHint.Visible );
        shader = new Fill3DShader;
        shader.projection = mat4.orthographic(
                -320, 320, 240, -240, short.min, short.max );

        triangle = new RegularNgonElement!3;
        triangle.resize(100f);

        foreach ( ref v; pos ) {
            v = vec3(uniform(-320,320),uniform(-240,240),uniform(short.min,short.max));
        }

        win.handler.onMouseMove = delegate ( vec2 pt )
        {
            const halfW = win.size.x/2, halfH = win.size.y/2;
            shader.rotation.y = (pt.x/halfW)*PI;
            shader.rotation.z = (pt.y/halfH)*PI;
        };
    }

    int exec ()
    {
        while ( win.alive )
        {
            win.pollEvents();
            win.resetFrame();

            shader.use();
            shader.color = vec4(1f,1f,1f,0.1f);
            foreach ( v; pos ) {
                shader.translate = v;
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
