//
//  Photo.h
//  Components
//  照片处理对象
//  Created by Liu Yang on 10-9-15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


typedef enum{
    UIImageRoundedCornerTopLeft=1,
    UIImageRoundedCornerTopRight=1<<1,
    UIImageRoundedCornerBottomRight=1<<2,
    UIImageRoundedCornerBottomLeft=1<<3
}UIImageRoundedCorner;

    
@interface Photo : NSObject {

}


+ (id) createRoundedRectImage:(UIImage*)image;
/*
 * 缩放图片
 * image 图片对象
 * toWidth 宽
 * toHeight 高
 * return 返回图片对象
 */
+(UIImage *)scaleImage:(UIImage *)image toWidth:(int)toWidth toHeight:(int)toHeight;

/*
 * 缩放图片数据
 * imageData 图片数据
 * toWidth 宽
 * toHeight 高
 * return 返回图片数据对象
 */
+(NSData *)scaleData:(NSData *)imageData toWidth:(int)toWidth toHeight:(int)toHeight;

/*
 * 圆角
 * image 图片对象
 * size 尺寸
 */
+(id) createRoundedRectImage:(UIImage*)image size:(CGSize)size;

/*
 * 圆角
 * image 图片对象
 * size 尺寸
 * r 弧度
 */

+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;

/*
 * 圆形
 * image 图片对象
 */
+(id) circleImage:(UIImage*)image;

/*
 * 图片转换为字符串
 */
+(NSString *) image2String:(UIImage *)image;

/*
 * 字符串转换为图片
 */
+(UIImage *) string2Image:(NSString *)string;

//roate image
+(UIImage *)rotateImage:(UIImage *)aImage;

//彩图转化为灰度图片
+ (UIImage*)getGrayImage:(UIImage*)sourceImage;


+ (UIImage*)thumbnailOfImage:(UIImage*)image;
+ (UIImage *)addBackgroundToImage:(UIImage *)image;
+ (UIImage  *)createThumbImage:(NSURL *)path;
+ (UIImage *)getLocationImgFromImage:(UIImage *)img;
+ (UIImage*)thumbnailOfHeith:(UIImage*)image height:(float)_height;
+ (UIImage*)thumbnailOfWidth:(UIImage*)image width:(float)_width;

+ (UIImage*)thumbnailOfImage:(UIImage*)image height:(float)_height width:(float)_width;

+ (UIImage*)roundedRectWith:(float)radius cornerMask:(UIImageRoundedCorner)cornerMask image:(UIImage *)image;

+ (UIImage *)rotationImage:(UIImage *)image degree:(double)degree;

+ (UIImage *)imageRotatedByImage:(UIImage *)image degrees:(CGFloat)degrees;
@end
