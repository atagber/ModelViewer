//
//  Program.h
//  ModelViewer
//
//  Created by Arman on 10.02.17.
//  Copyright © 2017 3d4medical. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/gl.h>

@interface Program : NSObject
@property (assign, nonatomic) GLuint program;
@property (assign, nonatomic) GLuint vertexShader;
@property (assign, nonatomic) GLuint fragmentShader;

- (instancetype)initWithVertexShaderFileName:(NSString *)vertexShaderFileName
                      fragmentShaderFileName:(NSString *)fragmentShaderFileName;

- (void)use;

@end
