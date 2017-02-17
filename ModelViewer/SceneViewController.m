//
//  SceneViewController.m
//  ModelViewer
//
//  Created by Arman on 10.02.17.
//  Copyright © 2017 3d4medical. All rights reserved.
//

#import "SceneViewController.h"
#import <OpenGLES/ES3/gl.h>
#import "Settings.h"
#import "Scene.h"
#import "ModelSetting.h"
#import "Program.h"
#import "Attribute.h"
#define PAN_MOVING_SCALE 5.0

@interface SceneViewController ()
@property (strong, nonatomic) Program *program;
@property (strong, nonatomic) Program *sunProgram;

@property (strong, nonatomic) EAGLContext *context;
@property (assign, nonatomic) GLuint renderBuffer;
@property (assign, nonatomic) GLuint frameBuffer;
@property (assign, nonatomic) CGPoint panPreviousPoint;

@end

@implementation SceneViewController

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  [self setupOpenGL];
  
  [self setupGestures];
  
  [self setupProgram];
  
  [self setupScene];
  
  [self setupSettings];
}

- (void)setupOpenGL {
  
  self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
  if (!self.context) {
    NSLog(@"<SceneViewController> Failed to create EAGLContext");
    exit(1);
  }
  
  GLKView *view = (GLKView *)self.view;
  view.context = self.context;
  view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
  
  [EAGLContext setCurrentContext:self.context];
  
  CAEAGLLayer *layer = (CAEAGLLayer *)view.layer;
  layer.opaque = YES;
  layer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking: @NO,
                               kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8};
  
  GLuint renderBuffer;
  glGenRenderbuffers(1, &renderBuffer);
  glBindBuffer(GL_RENDERBUFFER, renderBuffer);
  [self.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.view.layer];
  
  GLuint frameBuffer;
  glGenFramebuffers(1, &frameBuffer);
  glBindBuffer(GL_FRAMEBUFFER, frameBuffer);
  
  glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderBuffer);
  
  glEnable(GL_CULL_FACE);
  
  self.frameBuffer = frameBuffer;
  self.renderBuffer = renderBuffer;
  
  [view bindDrawable];
}

- (void)setupGestures {
  [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)]];
}

- (void)setupScene {
  
  ModelSetting *phone = [[ModelSetting alloc] initWithModelFileName:@"Heart.obj"]; // Lara_Croft.obj
  phone.worldScale = 1.0;
  phone.worldPosition = GLKVector3Make(0.0, 0.0, 0.0);
  
  phone.program = self.program;
  
  ModelSetting *sun1 = [[ModelSetting alloc] initWithModelFileName:@"sun.obj"];
  sun1.program = self.sunProgram;
  sun1.worldScale = 0.2;
  sun1.updateHandler = ^(GLKVector3 vector) {
    [Settings shared].light1PositionX.value = vector.x;
    [Settings shared].light1PositionY.value = vector.y;
    [Settings shared].light1PositionZ.value = vector.z;
  };
  
  ModelSetting *sun2 = [[ModelSetting alloc] initWithModelFileName:@"sun.obj"];
  sun2.program = self.sunProgram;
  sun2.worldScale = 0.2;
  sun2.updateHandler = ^(GLKVector3 vector) {
    [Settings shared].light2PositionX.value = vector.x;
    [Settings shared].light2PositionY.value = vector.y;
    [Settings shared].light2PositionZ.value = vector.z;
  };
  
  self.scene = [[Scene alloc] initWithModelSettings:@[phone, sun1, sun2]];
  
  [self.scene loadModels];
}

- (void)setupProgram {
  self.program = [[Program alloc] initWithVertexShaderFileName:@"shader.vsh"
                                        fragmentShaderFileName:@"shader.fsh"];
  
  self.sunProgram = [[Program alloc] initWithVertexShaderFileName:@"simple_object.vsh"
                                           fragmentShaderFileName:@"simple_object.fsh"];
}

- (void)setupSettings {
  Settings *settings = [Settings shared];
  settings.lookAtPoint = GLKVector3Make(0.0, 0.0, 0.0);
}

- (void)panHandler:(UIPanGestureRecognizer *)gesture {
  
  CGPoint location = [gesture locationInView:self.view];
  Settings *settings = [Settings shared];
  
  if (gesture.state == UIGestureRecognizerStateChanged) {
    float scaledDiffX = (self.panPreviousPoint.x - location.x) / PAN_MOVING_SCALE;
    float scaledDiffY = (self.panPreviousPoint.y - location.y) / PAN_MOVING_SCALE;
    
    GLKMatrix4 matrix = GLKMatrix4RotateY(GLKMatrix4Identity, GLKMathDegreesToRadians(scaledDiffX));
    matrix = GLKMatrix4Rotate(matrix, GLKMathDegreesToRadians(scaledDiffY), settings.cameraEye.z, 0, -1.0 * settings.cameraEye.x);
    settings.cameraEye = GLKMatrix4MultiplyVector3(matrix, settings.cameraEye);
  }
  self.panPreviousPoint = location;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
  [self renderWithX:rect.origin.x * 2
                  y:rect.origin.y * 2
              width:rect.size.width * 2
             height:rect.size.height * 2];
  
  [self.context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)renderWithX:(GLuint)x y:(GLuint)y width:(GLuint)width height:(GLuint)height {

  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LESS);
  
  glViewport(0, 0, width, height);

  [self.scene drawInProgram:self.program];
  
  [self drawLightsInProgram:self.program];
}

- (void)drawLightsInProgram:(Program *)program {

  

}

@end
