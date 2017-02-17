//
//  MainViewController.m
//  ModelLoader
//
//  Created by Arman on 07.02.17.
//  Copyright © 2017 pocoyo. All rights reserved.
//

#import "MainViewController.h"
#import "Settings.h"
#import "ModelSetting.h"
#import "SceneViewController.h"
#import "Scene.h"
#import "Attribute.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIButton *projectionDegreeButton;
@property (weak, nonatomic) IBOutlet UIButton *projectionAspectButton;
@property (weak, nonatomic) IBOutlet UIButton *projectionNearButton;
@property (weak, nonatomic) IBOutlet UIButton *projectionFarButton;

@property (weak, nonatomic) IBOutlet UIButton *light1XButton;
@property (weak, nonatomic) IBOutlet UIButton *light1YButton;
@property (weak, nonatomic) IBOutlet UIButton *light1ZButton;

@property (weak, nonatomic) IBOutlet UIButton *light2XButton;
@property (weak, nonatomic) IBOutlet UIButton *light2YButton;
@property (weak, nonatomic) IBOutlet UIButton *light2ZButton;

@property (weak, nonatomic) IBOutlet UISlider *valueSlider;
@property (weak, nonatomic) IBOutlet UILabel *maxValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *minValueLabel;

@property (weak, nonatomic) IBOutlet UIStackView *modelsStackView;
@property (weak, nonatomic) IBOutlet UISlider *modelXPositionSlider;
@property (weak, nonatomic) IBOutlet UISlider *modelYPositionSlider;
@property (weak, nonatomic) IBOutlet UISlider *modelZPositionSlider;
@property (weak, nonatomic) IBOutlet UISlider *modelScaleSlider;

@property (weak, nonatomic) Attribute *currentAttribute;
@property (weak, nonatomic) ModelSetting *currentModelSetting;
@property (strong, nonatomic) NSArray<Attribute *> *allAttributes;
@property (weak, nonatomic) UIButton *currentModelButton;

@property (weak, nonatomic) SceneViewController *sceneViewController;

@end

@implementation MainViewController {
  UIButton *_targetSender;
  GLfloat *_targetValueRef;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  for (UIViewController *controller in self.childViewControllers) {
    if ([controller isKindOfClass:SceneViewController.class]) {
      self.sceneViewController = (SceneViewController *)controller;
    }
  }
  
  [self setupRelationships];
  
  [self setupModelsView];
}

- (void)setupRelationships {
  Settings *settings = [Settings shared];
  
  settings.projectionDegree.info = self.projectionDegreeButton;
  settings.projectionAspect.info = self.projectionAspectButton;
  settings.projectionNear.info = self.projectionNearButton;
  settings.projectionFar.info = self.projectionFarButton;
  
  settings.light1PositionX.info = self.light1XButton;
  settings.light1PositionY.info = self.light1YButton;
  settings.light1PositionZ.info = self.light1ZButton;
  
  settings.light2PositionX.info = self.light2XButton;
  settings.light2PositionY.info = self.light2YButton;
  settings.light2PositionZ.info = self.light2ZButton;
  
  self.allAttributes = @[settings.light1PositionX,
                         settings.light1PositionY,
                         settings.light1PositionZ,
                         settings.light2PositionX,
                         settings.light2PositionY,
                         settings.light2PositionZ,
                         settings.projectionDegree,
                         settings.projectionAspect,
                         settings.projectionNear,
                         settings.projectionFar];
  
  for (Attribute *attribute in self.allAttributes) {
    if ([attribute.info isKindOfClass:UIButton.class]) {
      UIButton *button = (UIButton *)attribute.info;
      
      [button setTitle:[NSString stringWithFormat:@"%@", @(attribute.value)]
              forState:UIControlStateNormal];
      
      [button addTarget:self
                 action:@selector(changeCurrentAttributeButtonPressed:)
       forControlEvents:UIControlEventTouchUpInside];
    }
  }
}

- (void)setupModelsView {
  for (UIView *view in self.modelsStackView.arrangedSubviews) {
    [self.modelsStackView removeArrangedSubview:view];
  }
  
  for (NSUInteger i = 0; i < self.sceneViewController.scene.modelSettings.count; i++) {
    ModelSetting *setting = self.sceneViewController.scene.modelSettings[i];
    UIButton *button = [UIButton new];
    [button setTitle:setting.modelFileName forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(selectModelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = i;
    
    [self.modelsStackView addArrangedSubview:button];
  }
}

- (IBAction)changeCurrentAttributeButtonPressed:(UIButton *)button {
  Attribute *selectedAttribute;
  for (Attribute *attribute in self.allAttributes) {
    if (attribute.info == button) {
      selectedAttribute = attribute;
      break;
    }
  }
  if (selectedAttribute) {
    self.currentAttribute = selectedAttribute;
  }
}

- (IBAction)selectModelButtonPressed:(UIButton *)button {
  [_currentModelButton setBackgroundColor:UIColor.whiteColor];
  _currentModelButton = button;
  [_currentModelButton setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:1.0]];
  
  ModelSetting *setting = self.sceneViewController.scene.modelSettings[button.tag];
  if (setting) {
    self.currentModelSetting = setting;
  }
}

- (void)setCurrentModelSetting:(ModelSetting *)currentModelSetting {
  _currentModelSetting = currentModelSetting;
  
  self.modelXPositionSlider.value = currentModelSetting.worldPosition.x;
  self.modelYPositionSlider.value = currentModelSetting.worldPosition.y;
  self.modelZPositionSlider.value = currentModelSetting.worldPosition.z;
  self.modelScaleSlider.value = currentModelSetting.worldScale;
}

- (void)setCurrentAttribute:(Attribute *)attribute {
  
  [self currentButton].backgroundColor = [UIColor whiteColor];
  _currentAttribute = attribute;
  [self currentButton].backgroundColor = [UIColor colorWithRed:0.75f
                                                         green:0.75f
                                                          blue:0.75f
                                                         alpha:1.0f];
  self.valueSlider.maximumValue = attribute.max;
  self.valueSlider.minimumValue = attribute.min;
  self.valueSlider.value = attribute.value;
  
  self.maxValueLabel.text = [NSString stringWithFormat:@"%@", @(attribute.max)];
  self.minValueLabel.text = [NSString stringWithFormat:@"%@", @(attribute.min)];
}

- (void)changeValueOfCurrentAttributeTo:(GLfloat)value {
  if (self.currentAttribute) {
    self.currentAttribute.value = value;
    self.valueSlider.value = value;
    [[self currentButton] setTitle:[NSString stringWithFormat:@"%@", @(self.currentAttribute.value)]
                          forState:UIControlStateNormal];
    
    [[Settings shared] updateLight];
  }
}

- (UIButton *)currentButton {
  UIButton *button;
  
  if ([self.currentAttribute.info isKindOfClass:UIButton.class]) {
    button = (UIButton *)self.currentAttribute.info;
  }
  return button;
}

#pragma mark - IBActions

- (IBAction)zero:(UIButton *)sender {
  [self changeValueOfCurrentAttributeTo:0.0];
}

- (IBAction)increase:(UIButton *)sender {
  [self changeValueOfCurrentAttributeTo:self.currentAttribute.value + 0.1];
}

- (IBAction)decrease:(UIButton *)sender {
  [self changeValueOfCurrentAttributeTo:self.currentAttribute.value - 0.1];
}

- (IBAction)valueChanged:(UISlider *)sender {
  [self changeValueOfCurrentAttributeTo:sender.value];
}

- (IBAction)changeModelXPositionChanged:(UISlider *)slider {
  self.currentModelSetting.worldPosition = GLKVector3Make(slider.value, self.currentModelSetting.worldPosition.y, self.currentModelSetting.worldPosition.z);
}

- (IBAction)changeModelYPositionChanged:(UISlider *)slider {
  self.currentModelSetting.worldPosition = GLKVector3Make(self.currentModelSetting.worldPosition.x, slider.value, self.currentModelSetting.worldPosition.z);
}

- (IBAction)changeModelZPositionChanged:(UISlider *)slider {
  self.currentModelSetting.worldPosition = GLKVector3Make(self.currentModelSetting.worldPosition.x, self.currentModelSetting.worldPosition.y, slider.value);
}

- (IBAction)changeModelScaleChanged:(UISlider *)slider {
  self.currentModelSetting.worldScale = slider.value;
}

@end
