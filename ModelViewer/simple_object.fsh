#version 300 es
precision highp float;

out vec4 out_color;

uniform sampler2D u_textureSampler;

void main()
{
  out_color = vec4(1.0, 1.0, 0.0, 1.0); //textureColor * lightFactor;
}
