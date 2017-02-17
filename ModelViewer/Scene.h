//
//  Scene.h
//  ModelViewer
//
//  Created by Arman on 10.02.17.
//  Copyright © 2017 3d4medical. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Drawable.h"
#import <GLKit/GLKit.h>

@class ModelSetting;
@class Program;

@interface Scene : NSObject <Drawable>
@property (strong, nonatomic) NSArray<ModelSetting *> *modelSettings;
@property (assign, nonatomic) GLKVector3 boxMaxPoint;
@property (assign, nonatomic) GLKVector3 boxMinPoint;
@property (nonatomic) GLKVector3 centerPoint;
@property (nonatomic) GLfloat lengthX;
@property (nonatomic) GLfloat lengthY;
@property (nonatomic) GLfloat lengthZ;

- (instancetype)initWithModelSettings:(NSArray<ModelSetting *> *)settings;
- (void)loadModels;

@end
