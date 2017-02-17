//
//  ModelSettings.h
//  ModelViewer
//
//  Created by Arman on 10.02.17.
//  Copyright © 2017 3d4medical. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class Program;

@interface ModelSetting : NSObject
@property (strong, nonatomic) NSString *modelFileName;

@property (assign, nonatomic, readonly) GLKVector3 position;
@property (assign, nonatomic, readonly) GLfloat scale;

@property (assign, nonatomic) GLKVector3 worldPosition;
@property (assign, nonatomic) GLfloat worldScale;

@property (strong, nonatomic) Program *program;
@property (copy, nonatomic) void(^updateHandler)(GLKVector3 position);

- (instancetype)initWithModelFileName:(NSString *)fileName;
- (void)setupWithMesh:(MDLMesh *)mesh;
- (void)syncState;

@end
