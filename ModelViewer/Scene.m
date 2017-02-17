//
//  Scene.m
//  ModelViewer
//
//  Created by Arman on 10.02.17.
//  Copyright © 2017 3d4medical. All rights reserved.
//

#import "Scene.h"
#import "Model.h"
#import "Model+Factory.h"
#import "ModelSetting.h"

@interface Scene()
@property (strong, nonatomic) NSArray<Model *> *models;

@end

@implementation Scene

- (instancetype)initWithModelSettings:(NSArray<ModelSetting *> *)settings {
  self = [super init];
  if (self) {
    self.modelSettings = settings;
  }
  return self;
}

- (void)loadModels {
  float maxX = CGFLOAT_MIN;
  float maxY = CGFLOAT_MIN;
  float maxZ = CGFLOAT_MIN;
  
  float minX = CGFLOAT_MAX;
  float minY = CGFLOAT_MAX;
  float minZ = CGFLOAT_MAX;
  
  NSMutableArray *models = [NSMutableArray new];
  for (ModelSetting *setting in self.modelSettings) {
    Model *model = [Model buildModelWithSetting:setting];
    [models addObject:model];
    
    if (maxX < model.boxMaxPoint.x) maxX = model.boxMaxPoint.x;
    if (maxY < model.boxMaxPoint.y) maxY = model.boxMaxPoint.y;
    if (maxZ < model.boxMaxPoint.z) maxZ = model.boxMaxPoint.z;
    
    if (minX > model.boxMinPoint.x) minX = model.boxMinPoint.x;
    if (minY > model.boxMinPoint.y) minY = model.boxMinPoint.y;
    if (minZ > model.boxMinPoint.z) minZ = model.boxMinPoint.z;
  }
  
  self.boxMaxPoint = GLKVector3Make(maxX, maxY, maxZ);
  self.boxMinPoint = GLKVector3Make(minX, minY, minZ);
  self.models = models.copy;
}

- (void)drawInProgram:(Program *)program {
  for (Model *model in self.models) {
    [model drawInProgram:model.setting.program];
  }
}

- (GLKVector3)centerPoint {
  return GLKVector3Add(self.boxMinPoint, GLKVector3Make(self.lengthX / 2.0, self.lengthY / 2.0, self.lengthZ / 2.0));
}

- (GLfloat)lengthX {
  return ABS(self.boxMaxPoint.x - self.boxMinPoint.x);
}

- (GLfloat)lengthY {
  return ABS(self.boxMaxPoint.y - self.boxMinPoint.y);
}

- (GLfloat)lengthZ {
  return ABS(self.boxMaxPoint.z - self.boxMinPoint.z);
}

@end
