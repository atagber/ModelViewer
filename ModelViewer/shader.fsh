#version 300 es
#define M_PI 3.1415926535898
precision highp float;

in mediump vec2 texCoord;
in mediump vec3 worldNormal;
in vec4 worldPosition;

out vec4 out_color;

uniform sampler2D u_textureSampler;

uniform vec3 u_lightPosition1;
uniform vec3 u_cameraPosition;

void main()
{
  // Diffuse
  vec3 lightVectorWorld = normalize(u_lightPosition1 - worldPosition);
  
  float brightness = dot(lightVectorWorld, worldNormal);
  
  vec4 diffuceLight = vec4(vec3(brightness), 1.0);
  
  
  // Specular
  vec3 reflectedLightVectorWorld = reflect(-lightVectorWorld, worldNormal);
  
  vec3 eyeVectorWorld = normalize(u_cameraPosition - worldPosition);
  
  float specularLight = clamp(dot(reflectedLightVectorWorld, eyeVectorWorld), 0.0, 1.0);
  
  specularLight = pow(specularLight, 50)
  
  vec4 specularLight = vec4(vec3(specularLight), 1.0);
  
  vec4 ambientLight = vec4(vec3(0.2), 1.0);
  
  out_color = ambientLight + clamp(diffuceLight, 0.0, 1.0) + specularLight;
}
