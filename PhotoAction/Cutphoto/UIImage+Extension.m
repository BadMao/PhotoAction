//
//  UIImage+Extension.m
//  WeiBo
//
//  Created by zero on 15/3/30.
//  Copyright (c) 2015年 ckx. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)



+(UIImage *)imageWithName:(NSString *)name
{
    UIImage *image = nil;
    //    if(iOS7)// 处理iOS 7的情况
    //    {
    //        NSString *newName = [name stringByAppendingString:@"_os7"];
    //        image = [UIImage imageNamed:newName];
    //    }
    if(image == nil)
        image = [UIImage imageNamed:name];
    
    return image;
}

+(UIImage *)resizedImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    return  [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];
}

#pragma mark - 用于压缩图片
+(UIImage *)compressImageWith:(UIImage *)image
{
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float width = 120;
    float height = image.size.height/(image.size.width/width);
    
    float widthScale = imageWidth /width;
    float heightScale = imageHeight /height;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    if (widthScale > heightScale) {
        [image drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
    }
    else {
        [image drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
    }
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
#pragma -mark 图片剪切
-(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}
#pragma mark--压缩图片
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
#pragma mark - 保存图片至沙盒中
-(BOOL)saveImagePicName:(NSString*)fileName Image:(UIImage*)image
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    // 保存文件的名称
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    // 保存成功会返回YES
    BOOL result = [UIImagePNGRepresentation(image)writeToFile: filePath    atomically:YES];
    return result;
}
#pragma mark -取出保存好的图片
+(UIImage*)getSavedImageWithName:(NSString*)fileName
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    // 文件的名称
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    UIImage *image = [[UIImage alloc]initWithContentsOfFile:filePath];
    return image;
}

@end
