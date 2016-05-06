//
//  ViewController.m
//  PhotoAction
//
//  Created by ugiant-ios-pc on 16/5/5.
//  Copyright © 2016年 ugiant-ios-pc. All rights reserved.
//

#import "ViewController.h"
#import "SXPickPhoto.h"

@interface ViewController ()
@property (nonatomic,strong)  SXPickPhoto * pickPhoto;
@property (strong, nonatomic) IBOutlet UIImageView *imgV;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthLayout;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightLayoue;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _pickPhoto = [[SXPickPhoto alloc]init];

}

- (IBAction)headCut:(id)sender {
    NSLog(@"头像剪切");
    __weak typeof(self) weakSelf = self;
    
    _pickPhoto.VControllerl = self;
    //截图框的大小比例和压缩的比例
    _pickPhoto.cutSize  = 0.5;
    
    [_pickPhoto changeHeadImage];
    
    /**
     *  block 回调
     *
     *  回调压缩后的image,上传和更换操作在这里执行
     */
    _pickPhoto.myblock = ^(UIImage * image){
        
        weakSelf.imgV.image = image;
//        weakSelf.widthLayout.constant =  image.size.width ;
//        weakSelf.heightLayoue.constant =  image.size.height ;

        
        
    };

}
- (IBAction)morePicPicker:(id)sender {
    NSLog(@"多图选择");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
