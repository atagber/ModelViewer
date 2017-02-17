//
//  Program.m
//  ModelViewer
//
//  Created by Arman on 10.02.17.
//  Copyright © 2017 3d4medical. All rights reserved.
//

#import "Program.h"
#import "NSBundle+Helper.h"
#import "Settings.h"
#import "ModelSetting.h"
#import "Attribute.h"

@implementation Program

- (instancetype)initWithVertexShaderFileName:(NSString *)vertexShaderFileName
                      fragmentShaderFileName:(NSString *)fragmentShaderFileName
{
  self = [super init];
  if (self) {
    
    self.vertexShader = [self loadShaderWithFileName:vertexShaderFileName type:GL_VERTEX_SHADER];
    self.fragmentShader = [self loadShaderWithFileName:fragmentShaderFileName type:GL_FRAGMENT_SHADER];
    
    self.program = glCreateProgram();
    if (self.program == 0) {
      NSLog(@"<Program> Failed to create program");
      exit(1);
    }
    
    glAttachShader(self.program, self.vertexShader);
    glAttachShader(self.program, self.fragmentShader);
    
    glLinkProgram(self.program);
    
    GLint success;
    glGetProgramiv(self.program, GL_LINK_STATUS, &success);
    
    if (!success) {
      NSLog(@"<Program> Failed to link program with shaders: %@, %@", vertexShaderFileName, fragmentShaderFileName);
      GLint infoLen = 0;
      glGetProgramiv(self.program, GL_INFO_LOG_LENGTH, &infoLen);
      
      if (infoLen > 0) {
        char *infoLog = malloc(infoLen * sizeof(char));
        glGetProgramInfoLog(self.program, infoLen, NULL, infoLog);
        NSLog(@"Log: \n%@", [NSString stringWithCString:infoLog encoding:NSUTF8StringEncoding]);
      }
      
      exit(1);
    }
  }
  return self;
}

- (GLuint)loadShaderWithFileName:(NSString *)fileName type:(GLenum)type {
  
  NSBundle *mainBundle = [NSBundle mainBundle];
  
  NSURL *path = [mainBundle pathOfFileWithName:fileName];
  
  if (!path) {
    NSLog(@"<Program> Failed to find shader with name: %@ in main bundle", fileName);
    exit(1);
  }
  
  NSError *error;
  NSString *shaderSource = [NSString stringWithContentsOfURL:path
                                                    encoding:NSUTF8StringEncoding
                                                       error:&error];
  if (error) {
    NSLog(@"<Program> Failed to read shader with name: %@", fileName);
    exit(1);
  }
  
  GLuint shader = glCreateShader(type);
  if (shader == 0) {
    NSLog(@"<Program> Failed to create shader with type %@", @(type));
    exit(1);
  }
  
  const char *cShaderSource = [shaderSource cStringUsingEncoding:NSUTF8StringEncoding];
  glShaderSource(shader, 1, &cShaderSource, NULL);
  
  glCompileShader(shader);
  
  GLint success;
  glGetShaderiv(shader, GL_COMPILE_STATUS, &success);
  if (!success) {
    NSLog(@"<Program> Failed to compile shader with name: %@", fileName);
    GLint infoLen = 0;
    glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLen);
    
    if (infoLen > 0) {
      char *infoLog = malloc(infoLen * sizeof(char));
      glGetShaderInfoLog(shader, infoLen, NULL, infoLog);
      NSLog(@"Log: \n%@", [NSString stringWithCString:infoLog encoding:NSUTF8StringEncoding]);
    }
    
    exit(1);
  }
  
  return shader;
}

- (void)use {
  glUseProgram(self.program);
  
  Settings *settings = [Settings shared];
  
  GLKVector3 light1 = GLKVector3Make(settings.light1PositionX.value,
                                     settings.light1PositionY.value,
                                     settings.light1PositionZ.value);
  GLKVector3 light2 = GLKVector3Make(settings.light2PositionX.value,
                                     settings.light2PositionY.value,
                                     settings.light2PositionZ.value);
  
  GLKMatrix4 projection = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(settings.projectionDegree.value),
                                                    settings.projectionAspect.value,
                                                    settings.projectionNear.value,
                                                    settings.projectionFar.value);
  
  GLKMatrix4 view = GLKMatrix4MakeLookAt(settings.cameraEye.x,
                                         settings.cameraEye.y,
                                         settings.cameraEye.z,
                                         settings.cameraPosition.x,
                                         settings.cameraPosition.y,
                                         settings.cameraPosition.z,
                                         settings.cameraUp.x,
                                         settings.cameraUp.y,
                                         settings.cameraUp.z);
  
  glUniformMatrix4fv(glGetUniformLocation(self.program, "u_projection"), 1, GL_FALSE, projection.m);
  glUniformMatrix4fv(glGetUniformLocation(self.program, "u_view"), 1, GL_FALSE, view.m);
  glUniform3f(glGetUniformLocation(self.program, "u_lightPosition1"), light1.x, light1.y, light1.z);
  glUniform3f(glGetUniformLocation(self.program, "u_lightPosition2"), light2.x, light2.y, light2.z);
  glUniform3f(glGetUniformLocation(self.program, "u_cameraPosition"), settings.cameraPosition.x, settings.cameraPosition.y, settings.cameraPosition.z);
}

@end
