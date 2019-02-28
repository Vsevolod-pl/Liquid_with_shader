#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
varying vec4 vertColor;
varying vec4 vertTexCoord;

void main(void) {
  gl_FragColor = texture2D(texture,vertTexCoord.xy)+vec4(0,0,0.5,0);
}