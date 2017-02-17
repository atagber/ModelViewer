//
//  Material.m
//  ModelViewer
//
//  Created by Arman on 11.02.17.
//  Copyright © 2017 3d4medical. All rights reserved.
//

#import "Material.h"
#import <GLKit/GLKit.h>

@implementation Material
/*
 MDLMaterialPropertyTypeNone = 0, // default resulting from [MDLMaterialProperty init]
 MDLMaterialPropertyTypeString,
 MDLMaterialPropertyTypeURL,
 MDLMaterialPropertyTypeTexture,
 MDLMaterialPropertyTypeColor,
 MDLMaterialPropertyTypeFloat,
 MDLMaterialPropertyTypeFloat2,
 MDLMaterialPropertyTypeFloat3,
 MDLMaterialPropertyTypeFloat4,
 MDLMaterialPropertyTypeMatrix44
 */

- (instancetype)initWithMaterial:(MDLMaterial *)material
{
  self = [super init];
  if (self) {
    
    NSLog(@"Create new material with name: %@", material.name);
    
    for (NSUInteger i = 0; i < [material count]; i++) {
      MDLMaterialProperty *property = [material objectAtIndexedSubscript:i];
      [self getInformationFromProperty:property];
    }
    
    MDLScatteringFunction *function = [material scatteringFunction];
    
    [self getInformationFromProperty:[function ambientOcclusion]];
    [self getInformationFromProperty:[function ambientOcclusionScale]];
    [self getInformationFromProperty:[function baseColor]];
    [self getInformationFromProperty:[function emission]];
    [self getInformationFromProperty:[function interfaceIndexOfRefraction]];
    [self getInformationFromProperty:[function materialIndexOfRefraction]];
    [self getInformationFromProperty:[function normal]];
    [self getInformationFromProperty:[function specular]];
  }
  return self;
}

- (void)getInformationFromProperty:(MDLMaterialProperty *)property {
  switch (property.type) {
    case MDLMaterialPropertyTypeString:
      NSLog(@"String value: %@", [property stringValue]);
      break;
    case MDLMaterialPropertyTypeURL:
      NSLog(@"URL value: %@", [property URLValue]);
      break;
    case MDLMaterialPropertyTypeTexture:
      NSLog(@"Texture value: %@", [property textureSamplerValue]);
      break;
    case MDLMaterialPropertyTypeColor:
      NSLog(@"Color value: %@", [property color]);
      break;
    case MDLMaterialPropertyTypeFloat:
      NSLog(@"float value: %@", @([property floatValue]));
      break;
    case MDLMaterialPropertyTypeFloat2:
      NSLog(@"float2 value: %@", [property description]);
      break;
    case MDLMaterialPropertyTypeFloat3:
      NSLog(@"float3 value: %@", [property description]);
      break;
    case MDLMaterialPropertyTypeFloat4:
      NSLog(@"float4 value: %@", [property description]);
      break;
    case MDLMaterialPropertyTypeMatrix44:
      NSLog(@"matrix4x4 value:");
      break;
      
    default:
      break;
  }
}

@end
