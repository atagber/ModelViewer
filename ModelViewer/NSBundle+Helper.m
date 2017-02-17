//
//  NSBundle+Helper.m
//  ModelViewer
//
//  Created by Arman on 10.02.17.
//  Copyright © 2017 3d4medical. All rights reserved.
//

#import "NSBundle+Helper.h"

@implementation NSBundle (Helper)

- (NSURL *)pathOfFileWithName:(NSString *)fileName
{
  NSString *fileNameWithoutExtension = [fileName stringByDeletingPathExtension];
  NSString *extension = [fileName pathExtension];
  
  return [self URLForResource:fileNameWithoutExtension withExtension:extension];
}

@end
