//
//  SceneViewController.h
//  ModelViewer
//
//  Created by Arman on 10.02.17.
//  Copyright © 2017 3d4medical. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@class Scene;

@interface SceneViewController : GLKViewController
@property (strong, nonatomic) Scene *scene;

@end
