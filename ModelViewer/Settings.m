//
//  Settings.m
//  ModelLoader
//
//  Created by Arman on 07.02.17.
//  Copyright © 2017 pocoyo. All rights reserved.
//

#import "Settings.h"
#import "Attribute.h"
#import "ModelSetting.h"

@interface Settings ()

@end


@implementation Settings

- (instancetype)init
{
  self = [super init];
  if (self) {
    
    self.distanceToModel = [[Attribute alloc] initWithValue:10.0f max:20.f min:0.01];
    
    self.light1PositionX = [[Attribute alloc] initWithValue:2.0 max:10.0 min:0.01];
    self.light1PositionY = [[Attribute alloc] initWithValue:2.0 max:10.0 min:0.01];
    self.light1PositionZ = [[Attribute alloc] initWithValue:2.0 max:10.0 min:0.01];
    
    self.light2PositionX = [[Attribute alloc] initWithValue:-2.0 max:10.0 min:0.01];
    self.light2PositionY = [[Attribute alloc] initWithValue:-2.0 max:10.0 min:0.01];
    self.light2PositionZ = [[Attribute alloc] initWithValue:-2.0 max:10.0 min:0.01];
    
    self.projectionDegree = [[Attribute alloc] initWithValue:60.0 max:180.0 min:-180.0];
    self.projectionAspect = [[Attribute alloc] initWithValue:1.0 max:5.0 min:0.01];
    self.projectionFar = [[Attribute alloc] initWithValue:20.0f max:100.0 min:-100.0];
    self.projectionNear = [[Attribute alloc] initWithValue:0.1f max:100.0 min:-100.0];
    
    _cameraEye = GLKVector3Normalize(GLKVector3Make(1.0, 1.0, 1.0));
    _cameraUp = GLKVector3Make(0.0, 1.0, 0.0);
    _lookAtPoint = GLKVector3Make(0.0, 0.0, 0.0);
    
    [self updateCameraPosition];
  }
  return self;
}

+ (instancetype)shared {
  static Settings *instance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[self alloc] init];
  });
  return instance;
}

- (void)setCameraEye:(GLKVector3)cameraEye {
  _cameraEye = GLKVector3Normalize(cameraEye);
  [self updateCameraPosition];
}

- (void)setLookAtPoint:(GLKVector3)lookAtPoint {
  _lookAtPoint = lookAtPoint;
  [self updateCameraPosition];
}

- (void)updateCameraPosition {
  GLKVector3 cameraPosition = GLKVector3MultiplyScalar(self.cameraEye, -1.0 * self.distanceToModel.value);
  _cameraPosition = GLKVector3Add(cameraPosition, self.lookAtPoint);
}

@end
