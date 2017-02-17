//
//  Model+Factory.m
//  ModelViewer
//
//  Created by Arman on 10.02.17.
//  Copyright © 2017 3d4medical. All rights reserved.
//

#import "Model+Factory.h"
#import "ModelSetting.h"

@implementation Model (Factory)

+ (Model *)buildModelWithSetting:(ModelSetting *)setting {
  NSString *fileName = setting.modelFileName;
  NSBundle *mainBundle = [NSBundle mainBundle];
  NSString *fileNameWithoutExtension = [fileName stringByDeletingPathExtension];
  NSString *fileExtension = [fileName pathExtension];
  NSURL *path = [mainBundle URLForResource:fileNameWithoutExtension
                             withExtension:fileExtension];
  MDLAsset *asset = [[MDLAsset alloc] initWithURL:path];
  
  if (!asset || [asset count] == 0) {
    NSLog(@"<Scene> Failed to read content of mode: %@", fileName);
    exit(1);
  }
  
  if ([asset count] > 1) {
    NSLog(@"<Scene> Number of objects in model %@, more than one", fileName);
    exit(1);
  }
  
  MDLObject *object = [asset objectAtIndex:0];
  
  if ([object isKindOfClass:MDLMesh.class]) {
    return [[Model alloc] initWithSetting:setting mesh:(MDLMesh *)object];
  } else {
    NSLog(@"<Scene> Content of %@ file is not correct", fileName);
    exit(1);
  }
}

@end
