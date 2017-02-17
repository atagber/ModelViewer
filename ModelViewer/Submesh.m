//
//  Submesh.m
//  ModelViewer
//
//  Created by Arman on 10.02.17.
//  Copyright © 2017 3d4medical. All rights reserved.
//

#import "Submesh.h"

@implementation Submesh

- (instancetype)initWithIndexBuffer:(GLuint)indexBuffer
                         indexCount:(NSUInteger)indexCount
                            texture:(Texture *)texture
{
  self = [super init];
  if (self) {
    self.indexBuffer = indexBuffer;
    self.indexCount = indexCount;
    self.texture = texture;
  }
  return self;
}

@end
