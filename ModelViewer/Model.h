//
//  Model.h
//  ModelViewer
//
//  Created by Arman on 10.02.17.
//  Copyright © 2017 3d4medical. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ModelIO/ModelIO.h>
#import <GLKit/GLKit.h>
#import "Drawable.h"

@class ModelSetting;
@class Program;

@interface Model : NSObject <Drawable>
@property (assign, nonatomic) GLKVector3 boxMaxPoint;
@property (assign, nonatomic) GLKVector3 boxMinPoint;
@property (strong, nonatomic) ModelSetting *setting;

- (instancetype)initWithSetting:(ModelSetting *)setting mesh:(MDLMesh *)mesh;

@end
