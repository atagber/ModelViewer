//
//  Model.m
//  ModelViewer
//
//  Created by Arman on 10.02.17.
//  Copyright © 2017 3d4medical. All rights reserved.
//

#import "Model.h"
#import "Program.h"
#import "Submesh.h"
#import "Texture.h"
#import "Material.h"
#import "ModelSetting.h"
#define POSITION_ATTR_LOCATION 0
#define NORMAL_ATTR_LOCATION 1
#define TEXTURE_COORD_ATTR_LOCATION 2

@interface Model()
@property (assign, nonatomic) GLuint vertexBufferArray;
@property (strong, nonatomic) NSArray<Submesh *> *submeshes;
@property (strong, nonatomic) NSMutableDictionary *textures;

@end

@implementation Model

- (instancetype)initWithSetting:(ModelSetting *)setting mesh:(MDLMesh *)mesh {
  self = [super init];
  if (self) {
    self.setting = setting;
    [self.setting setupWithMesh:mesh];
    
    self.textures = [NSMutableDictionary new];
    
    if (mesh.vertexBuffers.count > 1) {
      NSLog(@"<Model> Number of vertex buffers in mesh more than one");
      exit(1);
    }
    
    [self setupVertexArrayWithMesh:mesh];
    
    NSMutableArray<Submesh *> *meshes = [NSMutableArray new];
    
    for (MDLSubmesh *submesh in mesh.submeshes) {
      GLuint indexBuffer;
      glGenBuffers(1, &indexBuffer);
      glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
      glBufferData(GL_ELEMENT_ARRAY_BUFFER, [submesh.indexBuffer length], submesh.indexBuffer.map.bytes, GL_STATIC_DRAW);
      
      MDLMaterial *material = submesh.material;
      Texture *texture = self.textures[material.name];
      
      if (!texture) {
        MDLMaterialProperty *property = [material objectForKeyedSubscript:@"baseColorMap"];
        if (property) {
          NSString *fileName = [property.stringValue lastPathComponent];
          texture = [[Texture alloc] initWithImageName:fileName];
          self.textures[material.name] = texture;
        } else {
          NSLog(@"There is no texture file for material with name: %@", material.name);
        }
      }
      
      Submesh *customSubmesh = [[Submesh alloc] initWithIndexBuffer:indexBuffer indexCount:submesh.indexCount texture:texture];
      [meshes addObject:customSubmesh];
    }
    
    self.submeshes = meshes.copy;
  }
  return self;
}

- (void)setupVertexArrayWithMesh:(MDLMesh *)mesh {
  id <MDLMeshBuffer> buffer = mesh.vertexBuffers.firstObject;
  
  GLuint vertexBufferArray;
  GLuint vertexBuffer;
  
  glGenVertexArrays(1, &vertexBufferArray);
  glGenBuffers(1, &vertexBuffer);
  
  glBindVertexArray(vertexBufferArray);
  
  glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
  glBufferData(GL_ARRAY_BUFFER, [buffer length], [buffer map].bytes, GL_STATIC_DRAW);
  
  MDLVertexAttribute *positionAttribute = [mesh.vertexDescriptor attributeNamed:@"position"];
  MDLVertexAttribute *normalAttribute = [mesh.vertexDescriptor attributeNamed:@"normal"];
  MDLVertexAttribute *textureCoordAttribute = [mesh.vertexDescriptor attributeNamed:@"textureCoordinate"];
  
  // stride value contains in layout array of mesh.vertexDescriptor
  GLuint stride = (GLuint)[buffer length] / [mesh vertexCount];
  
  if (positionAttribute) {
    glEnableVertexAttribArray(POSITION_ATTR_LOCATION);
    glVertexAttribPointer(POSITION_ATTR_LOCATION, 3, GL_FLOAT, GL_FALSE, stride, (void *)positionAttribute.offset); // 0
  }
  
  if (normalAttribute) {
    glEnableVertexAttribArray(NORMAL_ATTR_LOCATION);
    glVertexAttribPointer(NORMAL_ATTR_LOCATION, 3, GL_FLOAT, GL_FALSE, stride, (void *)normalAttribute.offset); // 12
  }
  
  if (textureCoordAttribute) {
    glEnableVertexAttribArray(TEXTURE_COORD_ATTR_LOCATION);
    glVertexAttribPointer(TEXTURE_COORD_ATTR_LOCATION, 2, GL_FLOAT, GL_FALSE, stride, (void *)textureCoordAttribute.offset); // 24
  }
  
  glBindVertexArray(0);
  
  self.vertexBufferArray = vertexBufferArray;
}

- (void)drawInProgram:(Program *)_ {
  [self.setting.program use];
  
  glBindVertexArray(self.vertexBufferArray);
  
  GLuint modelLocation = glGetUniformLocation(self.setting.program.program, "u_model");
  GLKMatrix4 modelMatrix = GLKMatrix4Identity;
  modelMatrix = GLKMatrix4Translate(modelMatrix, self.setting.position.x, self.setting.position.y, self.setting.position.z);
  modelMatrix = GLKMatrix4Scale(modelMatrix, self.setting.scale, self.setting.scale, self.setting.scale);
  
  // TODO: Add rotate
  glUniformMatrix4fv(modelLocation, 1, GL_FALSE, modelMatrix.m);
  
  for (Submesh *submesh in self.submeshes) {
    [self drawSubmesh:submesh inProgram:self.setting.program];
  }
  
  glBindVertexArray(0);
}

- (void)drawSubmesh:(Submesh *)submesh inProgram:(Program *)program {
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, submesh.indexBuffer);
  
  if (submesh.texture) {
    glActiveTexture(GL_TEXTURE0);
    
    glUniform1i(glGetUniformLocation(program.program, "u_textureSampler"), 0);
    glBindTexture(GL_TEXTURE_2D, submesh.texture.textureID);
  }
  
  GLsizei count = (GLsizei)submesh.indexCount;
  glDrawElements(GL_TRIANGLES, count, GL_UNSIGNED_INT, NULL);
  
  // Unbind texture
  glActiveTexture(GL_TEXTURE1);
  glBindTexture(GL_TEXTURE_2D, 0);
}

@end
