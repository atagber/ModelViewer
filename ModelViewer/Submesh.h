//
//  Submesh.h
//  ModelViewer
//
//  Created by Arman on 10.02.17.
//  Copyright © 2017 3d4medical. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ModelIO/ModelIO.h>
#import <OpenGLES/ES3/gl.h>

@class Texture;

@interface Submesh: NSObject
@property (assign, nonatomic) NSUInteger indexCount;
@property (assign, nonatomic) GLuint indexBuffer;
@property (strong, nonatomic) Texture *texture;

- (instancetype)initWithIndexBuffer:(GLuint)indexBuffer
                         indexCount:(NSUInteger)indexCount
                            texture:(Texture *)texture;

@end
