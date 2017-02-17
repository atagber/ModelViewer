#version 300 es
precision highp float;

layout (location = 0) in vec3 in_position;
layout (location = 1) in vec3 in_normal;
layout (location = 2) in vec2 in_texCoords;

out mediump vec2 texCoord;
out mediump vec3 worldNormal;
out vec4 worldPosition;

uniform mat4 u_model;
uniform mat4 u_view;
uniform mat4 u_projection;

void main()
{
  worldNormal = normalize((u_model * vec4(in_normal, 0.0)).xyz);
  texCoord = in_texCoords;
  worldPosition = u_model * vec4(in_position, 1.0);
  
  gl_Position = u_projection * u_view * worldPosition;
}
