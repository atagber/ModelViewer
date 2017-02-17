//
//  Material.h
//  ModelViewer
//
//  Created by Arman on 11.02.17.
//  Copyright © 2017 3d4medical. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ModelIO/ModelIO.h>

@interface Material : NSObject

- (instancetype)initWithMaterial:(MDLMaterial *)material;

@end
