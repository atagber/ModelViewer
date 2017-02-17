//
//  Floor.h
//  ModelViewer
//
//  Created by Arman on 13/02/2017.
//  Copyright © 2017 3d4medical. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/gl.h>
#import "Drawable.h"

@interface Floor : NSObject <Drawable>

- (instancetype)initWithCellSize:(GLfloat)cellSize lengthX:(GLfloat)lengthX lengthZ:(GLfloat)lengthZ;

@end
