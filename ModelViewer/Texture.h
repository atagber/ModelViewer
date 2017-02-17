#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Texture : NSObject
@property (nonatomic, assign) GLsizei width;
@property (nonatomic, assign) GLsizei height;
@property (nonatomic, assign) unsigned char *data;
@property (nonatomic, assign) GLuint textureID;

- (instancetype)initWithImagePath:(NSString *)imagePath;
- (instancetype)initWithImageName:(NSString *)imageName;
- (instancetype)initWithImage:(UIImage *)image;

@end
