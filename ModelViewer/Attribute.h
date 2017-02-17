//
//  Attribute.h
//  ModelLoader
//
//  Created by Arman on 08.02.17.
//  Copyright © 2017 pocoyo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/gl.h>

@interface Attribute : NSObject

@property (assign, nonatomic) GLfloat value;
@property (assign, readonly, nonatomic) GLfloat max;
@property (assign, readonly, nonatomic) GLfloat min;
@property (weak, nonatomic) id info;

- (instancetype)initWithValue:(GLfloat)value max:(GLfloat)max min:(GLfloat)min;

@end
