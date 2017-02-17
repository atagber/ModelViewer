//
//  Floor.m
//  ModelViewer
//
//  Created by Arman on 13/02/2017.
//  Copyright © 2017 3d4medical. All rights reserved.
//

#import "Floor.h"

@interface Floor ()

@end

@implementation Floor {
  GLfloat *_verteces;
  GLuint _counter;
  GLuint _numberOfVerteces;
}

- (instancetype)initWithCellSize:(GLfloat)cellSize lengthX:(GLfloat)lengthX lengthZ:(GLfloat)lengthZ {
  self = [super init];
  if (self) {
    GLuint numberOfLinesForX = lengthX / cellSize;
    GLuint numberOfLinesForZ = lengthZ / cellSize;
    _numberOfVerteces = (numberOfLinesForX + numberOfLinesForZ) * 2;
    GLuint size = _numberOfVerteces * 3; // x y z and for two point for line
    
    _verteces = calloc(size, sizeof(GLfloat));

    for (GLfloat x = -lengthX / 2.0; x < lengthX / 2.0; x += cellSize) {
      [self addVertexWithX:x z:lengthZ / 2.0];
      [self addVertexWithX:x z:-lengthZ / 2.0];
    }
    for (GLfloat z = -lengthZ / 2.0; z < lengthZ / 2.0; z += cellSize) {
      [self addVertexWithX:lengthX / 2.0 z:z];
      [self addVertexWithX:-lengthX / 2.0 z:z];
    }
  }
  return self;
}

- (void)addVertexWithX:(GLfloat)x z:(GLfloat)z {
  _verteces[_counter] = x;
  _verteces[_counter + 1] = 0.0;
  _verteces[_counter + 2] = z;
  _counter += 3;
}

- (void)setupVertexArray {
//  GLuint vertexArray;
//  GLuint vertexBuffer;
//  
//  GLuint numberOfVerteces =
//  
//  
//  glGenVertexArrays(1, &vertexArray);
//  glGenBuffers(1, &vertexBuffer);
//  
//  glBindVertexArray(vertexArray);
//  
//  glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
//  glBufferData(GL_ARRAY_BUFFER, <#GLsizeiptr size#>, verteces, GL_STATIC_DRAW);
//  
//  
  
  
}

- (void)drawInProgram:(Program *)program {
  
}

@end
