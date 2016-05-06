//
//  SXPickPhoto.m
//  SXPickphotos
//
//  Created by ShaoPro on 15/12/25.
//  Copyright © 2015年 ShaoPro. All rights reserved.
//

#import "SXPickPhoto.h"
#import "ImageClips.h"
#import "UIImage+Extension.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)//用来获取手机的系统，判断系统是多少


@implementation SXPickPhoto

- (instancetype)init
{
    if ([super init])
    {
      _picker = [[UIImagePickerController alloc] init];
    }
    return self;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld",buttonIndex);
    
    switch (buttonIndex) {
        case 0:
        {
            //拍照
            [self ShowTakePhotoWithController:_VControllerl];

        }
            break;
        case 1:
        {
            // 从相册中选取
            if ([self isPhotoLibraryAvailable]) {
                
                [self SHowLocalPhotoWithController:_VControllerl];
            }

        }
            break;
        default:
            break;
    }

    
}
-(void)changeHeadImage{
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        NSLog(@"I am 7.0");
//        _VControllerl = viewC;
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"上传照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
        [actionSheet showInView:_VControllerl.view];
    }
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 拍照
            
                [self ShowTakePhotoWithController:_VControllerl];
            
        }];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 从相册中选取
            if ([self isPhotoLibraryAvailable]) {

                [self SHowLocalPhotoWithController:_VControllerl];
            }
            
        }];
        UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [alertController addAction:deleteAction];
        [alertController addAction:archiveAction];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_VControllerl presentViewController:alertController animated:YES completion:nil];
        });
        
    }
    
    
}


#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}


- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}


#pragma mark --打开相机---
/**
 *  打开相机：
 *
 *  @param object 控制器对象
 */
- (void)ShowTakePhotoWithController: (UIViewController *)Controller

{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([self isCameraAvailable]&& [self doesCameraSupportTakingPhotos])
   
    {
        _picker.delegate = self;
      
        _picker.sourceType = sourceType;
        if ([self isFrontCameraAvailable]) {
            _picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        _picker.mediaTypes = mediaTypes;
        [Controller presentViewController:_picker animated:YES completion:nil];
     
    }
    else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
   
}

#pragma mark --选择相册---
/**
 *  选择相册
 *
 *  @param Controller 控制器对象
 */
- (void)SHowLocalPhotoWithController: (UIViewController *)Controller

{
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
    [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
    _picker.mediaTypes = mediaTypes;
    _picker.delegate = self;
    
    [Controller presentViewController:_picker animated:YES completion:nil];
}


//当一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

        [_picker dismissViewControllerAnimated:NO completion:^{
            UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            portraitImg = [self imageByScalingToMaxSize:portraitImg];
            NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
            //当选择的类型是图片
            if ([type isEqualToString:@"public.image"])
            {
                //图片可编辑
                ImageClips *imgVC = [[ImageClips alloc] init];
                [imgVC setReturnBlock:^(UIImage *img_clip) {
                    float height =  self.cutSize > 0?self.cutSize:1;
                    UIImage *image =  [UIImage imageWithImageSimple:img_clip scaledToSize:CGSizeMake(640,640*height)];
                    
                    if (_myblock)
                    {
                        _myblock(image);
                        
                        [self.VControllerl.navigationController popViewControllerAnimated:YES];
                    }
                    
                } image:portraitImg control:self.cutSize > 0?self.cutSize:1];
                
           
                    [self.VControllerl.navigationController pushViewController:imgVC animated:YES];
                
            }
        }];
    
    
 
    
}
#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < [UIScreen mainScreen].bounds.size.height) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = [UIScreen mainScreen].bounds.size.height;
        btWidth = sourceImage.size.width * ([UIScreen mainScreen].bounds.size.height / sourceImage.size.height);
    } else {
        btWidth = [UIScreen mainScreen].bounds.size.height;
        btHeight = sourceImage.size.height * ([UIScreen mainScreen].bounds.size.height / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}
- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


// 取消选择照片:
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker

{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
   
}






@end
