//
//  Model+Factory.h
//  ModelViewer
//
//  Created by Arman on 10.02.17.
//  Copyright © 2017 3d4medical. All rights reserved.
//

#import "Model.h"

@interface Model (Factory)

+ (Model *)buildModelWithSetting:(ModelSetting *)setting;
  
@end
