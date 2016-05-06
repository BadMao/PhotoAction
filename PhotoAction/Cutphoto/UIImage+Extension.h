//
//  UIImage+Extension.h
//  WeiBo
//
//  Created by zero on 15/3/30.
//  Copyright (c) 2015年 ckx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

+(UIImage *)imageWithName:(NSString*)name;


+(UIImage *)resizedImage:(NSString*)imageName;
#pragma mark - 用于压缩图片
+(UIImage *)compressImageWith:(UIImage *)image;

#pragma mark - 切圆tu
-(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset;
#pragma mark--压缩图片
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

#pragma mark - 保存图片致沙盒中
-(BOOL)saveImagePicName:(NSString*)fileName Image:(UIImage*)image;
#pragma mark -取出保存好的图片
+(UIImage*)getSavedImageWithName:(NSString*)fileName;

@end
