//
//  SXPickPhoto.h
//  SXPickphotos
//
//  Created by ShaoPro on 15/12/25.
//  Copyright © 2015年 ShaoPro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

/**
 *  相册选择
 */
@interface SXPickPhoto : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

/**
 *  相册选择器
 */
@property (nonatomic,strong) UIImagePickerController *picker;

/**
 *  block回调image
 */
@property (nonatomic,strong) void(^myblock)(UIImage * image);

/**
 *  截图框的大小比例和压缩的比例
 */
@property () float cutSize;


@property (nonatomic,strong) UIViewController *VControllerl;


-(void)changeHeadImage;

@end
