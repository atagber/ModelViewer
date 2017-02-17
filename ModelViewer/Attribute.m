//
//  Attribute.m
//  ModelLoader
//
//  Created by Arman on 08.02.17.
//  Copyright © 2017 pocoyo. All rights reserved.
//

#import "Attribute.h"

@implementation Attribute

- (instancetype)initWithValue:(GLfloat)value max:(GLfloat)max min:(GLfloat)min {
  self = [super init];
  if (self) {
    _value = value;
    _max = max;
    _min = min;
  }
  return self;
}

@end
