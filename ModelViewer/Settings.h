//
//  Settings.h
//  ModelLoader
//
//  Created by Arman on 07.02.17.
//  Copyright © 2017 pocoyo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/gl.h>
#import <GLKit/GLKit.h>

@class ModelSetting;
@class Attribute;

@interface Settings : NSObject

@property (strong, nonatomic) Attribute *light1PositionX;
@property (strong, nonatomic) Attribute *light1PositionY;
@property (strong, nonatomic) Attribute *light1PositionZ;

@property (strong, nonatomic) Attribute *light2PositionX;
@property (strong, nonatomic) Attribute *light2PositionY;
@property (strong, nonatomic) Attribute *light2PositionZ;

@property (strong, nonatomic) Attribute *projectionDegree;
@property (strong, nonatomic) Attribute *projectionAspect;
@property (strong, nonatomic) Attribute *projectionNear;
@property (strong, nonatomic) Attribute *projectionFar;

@property (strong, nonatomic) Attribute *distanceToModel;

@property (nonatomic) GLKVector3 cameraEye;
@property (nonatomic) GLKVector3 lookAtPoint;
@property (nonatomic) GLKVector3 cameraUp;

@property (nonatomic, readonly) GLKVector3 cameraPosition;

+ (instancetype)shared;

- (void)updateLight;

@end
