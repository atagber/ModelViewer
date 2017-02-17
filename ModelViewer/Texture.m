#import "Texture.h"
#import <OpenGLES/ES3/gl.h>

@implementation Texture

- (instancetype)initWithImage:(UIImage *)image {
  self = [super init];
  if (self) {
    [self setupWithImage:image];
    [self loadTextureToBuffer];
  }
  return self;
}

- (instancetype)initWithImageName:(NSString *)imageName {
  self = [super init];
  if (self) {
    NSString *extension = [imageName pathExtension];
    NSString *filename = [imageName stringByDeletingPathExtension];
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:extension];
    
    if (!path) {
      NSLog(@"Failed to find image with name: %@ in main bundle", imageName);
      exit(1);
    }
    
    NSLog(@"Load texture with name: %@", imageName);
    [self setupWithFilePath:path];
  }
  return self;
}

- (instancetype)initWithImagePath:(NSString *)imagePath {
  self = [super init];
  if (self) {
    [self setupWithFilePath:imagePath];
  }
  return self;
}

- (void)setupWithFilePath:(NSString *)filePath {
  UIImage *image = [UIImage imageWithContentsOfFile:filePath];
  
  if (!image) {
    NSLog(@"Failed load image at path %@", filePath);
    exit(1);
  }
  
  [self setupWithImage:image];
  [self loadTextureToBuffer];
}

- (void)setupWithImage:(UIImage *)image {
  
  CGImageRef imageRef = [image CGImage];
  self.width = (GLsizei)CGImageGetWidth(imageRef);
  self.height = (GLsizei)CGImageGetHeight(imageRef);
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  
  NSUInteger numberOfComponentsInColor = 4;
  
  // calloc ~ malloc, but calloc is used for arrays with initial 0 value for each element
  self.data = (unsigned char *) calloc(self.height * self.width * numberOfComponentsInColor,
                                       sizeof(unsigned char));
  
  NSUInteger bytesPerPixel = 4;
  NSUInteger bytesPerRow = bytesPerPixel * self.width;
  NSUInteger bitsPerComponent = 8;
  CGContextRef context = CGBitmapContextCreate(self.data, self.width, self.height,
                                               bitsPerComponent, bytesPerRow, colorSpace,
                                               kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast);
  CGColorSpaceRelease(colorSpace);
  CGContextDrawImage(context, CGRectMake(0, 0, self.width, self.height), imageRef);
}

- (void)loadTextureToBuffer {
  GLuint textureID;
  glGenTextures(1, &textureID);
  glBindTexture(GL_TEXTURE_2D, textureID);
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, self.width, self.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, self.data);
  glGenerateMipmap(GL_TEXTURE_2D);
  
  // Parameters
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  glBindTexture(GL_TEXTURE_2D, 0);
  free(self.data);
  
  self.textureID = textureID;
}

@end
