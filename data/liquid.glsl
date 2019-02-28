#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform float mx;
uniform vec4 lcolor;

uniform int pC;
uniform float px[100];
uniform float py[100];

uniform sampler2D texture;
varying vec4 vertTexCoord;

float ball(vec2 r) {
    return 0.01 / length(r);
}

void main(void) {
    float d=0.;
    vec2 uv = vertTexCoord.xy;
    uv.x*=mx;
    for(int i=0;i<pC;i++){
        d+=ball(
        vec2(px[i]*mx,1.-py[i]*mx)
        -uv);
    }
    d=(d-min(d,0.999))/0.001;
    d=clamp(d,0.,1.);
    gl_FragColor = (1.-d)*texture2D(texture,vertTexCoord.xy)+
    d*lcolor;
}