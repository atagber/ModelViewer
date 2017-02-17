//
//  ModelSettings.m
//  ModelViewer
//
//  Created by Arman on 10.02.17.
//  Copyright © 2017 3d4medical. All rights reserved.
//

#import "ModelSetting.h"

@interface ModelSetting ()
@property (assign, nonatomic) GLKVector3 modelCenter;
@property (assign, nonatomic) GLfloat modelScale;

@property (assign, nonatomic) GLKVector3 boxMaxPoint;
@property (assign, nonatomic) GLKVector3 boxMinPoint;

@end

@implementation ModelSetting

- (instancetype)initWithModelFileName:(NSString *)fileName {
  self = [super init];
  if (self) {
    self.modelFileName = fileName;
  }
  return self;
}

- (void)setupWithMesh:(MDLMesh *)mesh {
  
  // init model center position
  self.boxMaxPoint = GLKVector3Make(mesh.boundingBox.maxBounds.x, mesh.boundingBox.maxBounds.y, mesh.boundingBox.maxBounds.z);
  self.boxMinPoint = GLKVector3Make(mesh.boundingBox.minBounds.x, mesh.boundingBox.minBounds.y, mesh.boundingBox.minBounds.z);
  self.modelCenter = GLKVector3Make((self.boxMaxPoint.x + self.boxMinPoint.x) / 2.0,
                                    (self.boxMaxPoint.y + self.boxMinPoint.y) / 2.0,
                                    (self.boxMaxPoint.z + self.boxMinPoint.z) / 2.0);
  
  // init model scale
  GLfloat lengthX = fabsf(self.boxMaxPoint.x - self.boxMinPoint.x);
  GLfloat lengthY = fabsf(self.boxMaxPoint.y - self.boxMinPoint.y);
  GLfloat lengthZ = fabsf(self.boxMaxPoint.z - self.boxMinPoint.z);
  self.modelScale = 1.0 / fmaxf(fmaxf(lengthX, lengthY), lengthZ);
  
  [self syncState];
}

- (void)setWorldScale:(GLfloat)worldScale {
  _worldScale = worldScale;
  [self syncState];
}

- (void)setWorldPosition:(GLKVector3)worldPosition {
  _worldPosition = worldPosition;
  [self syncState];
  
  if (self.updateHandler) {
    self.updateHandler(self.position);
  }
}

- (void)syncState {
  _position = GLKVector3Add(self.worldPosition, GLKVector3Negate(self.modelCenter));
  _scale = self.worldScale * self.modelScale;
}

@end
