//
//  CameraViewController.h
//  Muse
//
//  Created by HaiQuan on 2016/11/19.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MSViewController.h"
#import "BlueToothHelper.h"
#import "SettingHeaderBar.h"

#import <AVFoundation/AVFoundation.h>

@interface CameraViewController : MSViewController

@property IBOutlet UILabel *detailLbl;
@property IBOutlet UIButton *flashOnBtn;
@property IBOutlet UIButton *flashOffBtn;
@property IBOutlet UIButton *cameraDirectionBtn;



//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;

//当启动摄像头开始捕获输入
@property(nonatomic)AVCaptureMetadataOutput *output;

@property (nonatomic)AVCaptureStillImageOutput *ImageOutPut;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;



@property (nonatomic)UIImageView *imageView;
@property (nonatomic)UIView *focusView;
@property (nonatomic)BOOL isflashOn;
@property (nonatomic)UIImage *image;

@property (nonatomic)BOOL canCa;

@property IBOutlet UIButton *takePhotoBtn;

@property IBOutlet UILabel *flashLbl;


@end
