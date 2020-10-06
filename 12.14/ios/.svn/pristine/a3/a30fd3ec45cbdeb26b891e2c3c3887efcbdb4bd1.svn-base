//
//  HomeViewCollectModel.m
//  Muse
//
//  Created by pg on 16/5/13.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "HomeViewCollectModel.h"

#import "NoticeViewController.h"
#import "SearchDeviceViewController.h"
#import "AntiLostViewController.h"
#import "LCSOSViewController.h"
//#import "ClockSettingViewController.h"
#import "SettingViewController.h"
#import "SecretTalkViewController.h"
#import "MorseViewController.h"

#import "MBProgressHUD+Simple.h"
#import "HomeCollectionViewCell.h"

#import "BlueToothHelper.h"

@implementation HomeViewCollectModel {
    
    UIImagePickerController *_imagePicker;
}

#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"HomeCollectionViewCell";
    HomeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.cellData = self.fatherVC.mycollectionViewArr[indexPath.row];
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(collectionView.frame.size.width/2, collectionView.frame.size.height/3);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark --UICollectionViewDelegate
#pragma mark --<takePhoto>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    TypeDetailViewController *vc = [[TypeDetailViewController alloc]initWithNibName:@"TypeDetailViewController" bundle:nil];
//    [self.fatherVC.navigationController pushViewController:vc animated:YES];
    
 //   MSLog(@"%ld",(long)indexPath.row);
    switch (indexPath.row ) {
        case 0:
            [self settingNotice:nil];
            break;
        case 1:
//            [self takePhoto:nil];
            [self setToSecretTalk:nil];
            break;
        case 2:
            [self settingAntiLost:nil];
            break;
        case 3:
            [self settingSOS:nil];
            break;
        case 4:
//            [self settingClock:nil];
            [self sendMorseCode:nil];
            break;
        case 5: // 设置
            [self clickedSetting:nil];
            break;
        default:
            break;
    }
}

#pragma mark - Functions
//来电
- (void)settingNotice:(id)sender {
    NoticeViewController *vc = [[NoticeViewController alloc] init];
    [self.fatherVC.navigationController pushViewController:vc animated:YES];
}

//- (void)takePhoto:(id)sender {
//    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        [MBProgressHUD showHUDWithMessageOnly:@"此设备不支持拍照"];
//        return;
//    }
//    
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.delegate = self;
//    picker.allowsEditing = YES;
//    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    
//    [self.fatherVC presentViewController:picker animated:YES completion:NULL];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:picker selector:@selector(takePicture) name:ReceivedTakePictureNotification object:nil];
//}

//M你
- (void)setToSecretTalk:(id)sender {
    SecretTalkViewController *vc = [[SecretTalkViewController alloc] init];
    [self.fatherVC.navigationController pushViewController:vc animated:YES];
}
//防丢
- (void)settingAntiLost:(id)sender {
    AntiLostViewController *vc = [[AntiLostViewController alloc] init];
    [self.fatherVC.navigationController pushViewController:vc animated:YES];
}
//SOS
- (void)settingSOS:(id)sender {
    LCSOSViewController *vc = [[LCSOSViewController alloc] init];
    [self.fatherVC.navigationController pushViewController:vc animated:YES];
}

//- (void)settingClock:(id)sender {
//    ClockSettingViewController *vc = [[ClockSettingViewController alloc] init];
//    [self.fatherVC.navigationController pushViewController:vc animated:YES];
//}
//摩斯
- (void)sendMorseCode:(id)sender {
    MorseViewController *vc = [[MorseViewController alloc] init];
    [self.fatherVC.navigationController pushViewController:vc animated:YES];
}

/** 点击了设置 */
- (void)clickedSetting:(id)sender {
    SettingViewController *setting = [[SettingViewController alloc] init];
    [self.fatherVC.navigationController pushViewController:setting animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [MBProgressHUD showHUDWithMessageOnly:@"照片保存失败"];
    } else {
        [MBProgressHUD showHUDWithMessageOnly:@"照片已保存到相册"];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    if (!chosenImage) {
        chosenImage = info[UIImagePickerControllerOriginalImage];
    }
    UIImageWriteToSavedPhotosAlbum(chosenImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    [self imagePickerControllerDidCancel:picker];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [[NSNotificationCenter defaultCenter] removeObserver:picker];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


@end
