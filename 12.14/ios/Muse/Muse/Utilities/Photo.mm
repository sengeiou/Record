//
//  Photo.m
//  Components
//  照片处理对象
//  Created by Liu Yang on 10-9-15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Photo.h"

@interface NSData (MBBase64)

+ (id)dataWithBase64EncodedString:(NSString *)string;     //  Padding '=' characters are optional. Whitespace is ignored.
- (NSString *)base64Encoding;
@end

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation NSData (MBBase64)

+ (id)dataWithBase64EncodedString:(NSString *)string;
{
	if (string == nil)
		[NSException raise:NSInvalidArgumentException format:@""];
	if ([string length] == 0)
		return [NSData data];
	
	static char *decodingTable = NULL;
	if (decodingTable == NULL)
	{
		decodingTable = (char *)malloc(256);
		if (decodingTable == NULL)
			return nil;
		memset(decodingTable, CHAR_MAX, 256);
		NSUInteger i;
		for (i = 0; i < 64; i++)
			decodingTable[(short)encodingTable[i]] = i;
	}
	
	const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
	if (characters == NULL)     //  Not an ASCII string!
		return nil;
	char *bytes = (char *)malloc((([string length] + 3) / 4) * 3);
	if (bytes == NULL)
		return nil;
	NSUInteger length = 0;
	
	NSUInteger i = 0;
	while (YES)
	{
		char buffer[4];
		short bufferLength;
		for (bufferLength = 0; bufferLength < 4; i++)
		{
			if (characters[i] == '\0')
				break;
			if (isspace(characters[i]) || characters[i] == '=')
				continue;
			buffer[bufferLength] = decodingTable[(short)characters[i]];
			if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
			{
				free(bytes);
				return nil;
			}
		}
		
		if (bufferLength == 0)
			break;
		if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
		{
			free(bytes);
			return nil;
		}
		
		//  Decode the characters in the buffer to bytes.
		bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
		if (bufferLength > 2)
			bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
		if (bufferLength > 3)
			bytes[length++] = (buffer[2] << 6) | buffer[3];
	}
	
	realloc(bytes, length);
	return [NSData dataWithBytesNoCopy:bytes length:length];
}

- (NSString *)base64Encoding;
{
	if ([self length] == 0)
		return @"";
	
    char *characters = (char *)malloc((([self length] + 2) / 3) * 4);
	if (characters == NULL)
		return nil;
	NSUInteger length = 0;
	
	NSUInteger i = 0;
	while (i < [self length])
	{
		char buffer[3] = {0,0,0};
		short bufferLength = 0;
		while (bufferLength < 3 && i < [self length])
			buffer[bufferLength++] = ((char *)[self bytes])[i++];
		
		//  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
		characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
		characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
		if (bufferLength > 1)
			characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
		else characters[length++] = '=';
		if (bufferLength > 2)
			characters[length++] = encodingTable[buffer[2] & 0x3F];
		else characters[length++] = '=';	
	}
	
	return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

@end


@implementation Photo

#pragma mark -
#pragma mark 内部方法

+(NSString *) image2String_:(UIImage *)image{
	NSMutableDictionary *systeminfo = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"systeminfo"]];
    float o = 0.1;
	if (!image){//如果没有图则不操作
		return @"";
	}
	image = [self scaleImage:image toWidth:image.size.width/3 toHeight:image.size.height/3];
	if (systeminfo){//如果有系统设置信息
		if ([[systeminfo objectForKey:@"imagesize"] isEqualToString:@"大"]){
			o=0.7;
		}
		if ([[systeminfo objectForKey:@"imagesize"] isEqualToString:@"中"]){
			o=0.5;
		}
		if ([[systeminfo objectForKey:@"imagesize"] isEqualToString:@"小"]){
			o=0.2;
		}
	}
	NSData* pictureData = UIImageJPEGRepresentation(image,o);
	NSString* pictureDataString = [pictureData base64Encoding];
	
	return pictureDataString;
}

+(NSString *) image2String:(UIImage *)image{
    if (!image){//如果没有图则不操作
		return @"";
	}
    NSData*picData = UIImagePNGRepresentation(image);
    return [picData base64Encoding];
}

+(UIImage *) string2Image:(NSString *)string{
	UIImage *image = [UIImage imageWithData:[NSData dataWithBase64EncodedString:string]];
	return image;
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,float ovalHeight){
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
		CGContextAddRect(context, rect);
		return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}


+ (UIImage*)getGrayImage:(UIImage*)sourceImage
{
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    CGImageRef grayImageRef = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:grayImageRef];
    CGContextRelease(context);
    CGImageRelease(grayImageRef);
    
    return grayImage;
}

+ (id) createRoundedRectImage:(UIImage*)image{
    // the size of CGContextRef
    int w = image.size.width;
    int h = image.size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, 10, 10);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    UIImage *result= [UIImage imageWithCGImage:imageMasked];
    CGImageRelease(imageMasked);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return result;
}


+ (id) createRoundedRectImage:(UIImage*)image size:(CGSize)size{
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, 10, 10);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
	UIImage *result= [UIImage imageWithCGImage:imageMasked];
	CGImageRelease(imageMasked);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return result;
}

+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r
{
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, r, r);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    
    return img;
}

+(id) circleImage:(UIImage*)image
{
//    CGFloat scale = image.scale;
    CGFloat scale = [UIScreen mainScreen].scale;

    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    
    CGSize s;
    
    if (w > h)
    {
        s = CGSizeMake(h, h);
    }
    else
    {
        s = CGSizeMake(w, w);
    }
    
    CGRect rect = CGRectMake(0, 0, s.width, s.height);
    
//    UIGraphicsBeginImageContextWithOptions(s, NO, 2.0);
    UIGraphicsBeginImageContextWithOptions(s, NO, scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(ctx);
    addRoundedRectToPath(ctx, rect, s.width/2, s.width/2);
    CGContextClosePath(ctx);
    CGContextClip(ctx);
    
    [image drawInRect:rect];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    return image;
    
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
//    CGRect rect = CGRectMake(0, 0, w, h);
//    
//    CGContextBeginPath(context);
//    addRoundedRectToPath(context, rect, w/2, w/2);
//    CGContextClosePath(context);
//    CGContextClip(context);
//    CGContextDrawImage(context, rect, image.CGImage);
//    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
////	UIImage *result = [UIImage imageWithCGImage:imageMasked];
//    UIImage *result = [UIImage imageWithCGImage:imageMasked scale:scale orientation:image.imageOrientation];
//	CGImageRelease(imageMasked);
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//    return result;
}

+(UIImage *)scaleImage:(UIImage *)image toWidth:(int)toWidth toHeight:(int)toHeight{
	int width=0;
	int height=0;
	int x=0;
	int y=0;
	
    if (image.size.width < image.size.height) {
        
        if (image.size.width<toWidth){
            width = toWidth;
            height = image.size.height*(toWidth/image.size.width);
            y = (height - toHeight)/2;
        }else if (image.size.height<toHeight){
            height = toHeight;
            width = image.size.width*(toHeight/image.size.height);
            x = (width - toWidth)/2;
        }else if (image.size.width>toWidth){
            width = toWidth;
            height = image.size.height*(toWidth/image.size.width);
            y = (height - toHeight)/2;
        }else if (image.size.height>toHeight){
            height = toHeight;
            width = image.size.width*(toHeight/image.size.height);
            x = (width - toWidth)/2;
        }else{
            height = toHeight;
            width = toWidth;
        }
        
        
    }
    else
    {
        if (image.size.height<toHeight){
            height = toHeight;
            width = image.size.width*(toHeight/image.size.height);
            x = (height - toHeight)/2;
        }else if (image.size.width<toWidth){
            width = toWidth;
            height = image.size.height*(toWidth/image.size.width);
            y = (width - toWidth)/2;
        }else if (image.size.height>toHeight){
            height = toHeight;
            width = image.size.width*(toHeight/image.size.height);
            x = (width - toWidth)/2;
        }else if (image.size.width>toWidth){
            width = toWidth;
            height = image.size.height*(toWidth/image.size.width);
            y = (height - toHeight)/2;
        }else{
            height = toHeight;
            width = toWidth;
        }
        
    }
    
    
	CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
	
//	CGSize subImageSize = CGSizeMake(toWidth, toHeight);
//    CGRect subImageRect = CGRectMake(x, y, toWidth, toHeight);
//    CGImageRef imageRef = image.CGImage;
//    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
//    UIGraphicsBeginImageContext(subImageSize);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextDrawImage(context, subImageRect, subImageRef);
//    UIImage* subImage = [UIImage imageWithCGImage:subImageRef];
//	CGImageRelease(subImageRef);
//    UIGraphicsEndImageContext();
//	return subImage;
}


+(NSData *)scaleData:(NSData *)imageData toWidth:(int)toWidth toHeight:(int)toHeight{
	UIImage *image = [[UIImage alloc] initWithData:imageData];
	int width=0;
	int height=0;
	int x=0;
	int y=0;
	
	if (image.size.width<toWidth){
	    width = toWidth;
		height = image.size.height*(toWidth/image.size.width);
		y = (height - toHeight)/2;
	}else if (image.size.height<toHeight){
		height = toHeight;
		width = image.size.width*(toHeight/image.size.height);
		x = (width - toWidth)/2;
	}else if (image.size.width>toWidth){
	    width = toWidth;
		height = image.size.height*(toWidth/image.size.width);
		y = (height - toHeight)/2;
	}else if (image.size.height>toHeight){
		height = toHeight;
		width = image.size.width*(toHeight/image.size.height);
		x = (width - toWidth)/2;
	}else{
		height = toHeight;
		width = toWidth;
	}
	
	CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImageJPEGRepresentation(image,1.0);
	
//	CGSize subImageSize = CGSizeMake(toWidth, toHeight);
//    CGRect subImageRect = CGRectMake(x, y, toWidth, toHeight);
//    CGImageRef imageRef = image.CGImage;
//    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
//    UIGraphicsBeginImageContext(subImageSize);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextDrawImage(context, subImageRect, subImageRef);
//    UIImage* subImage = [UIImage imageWithCGImage:subImageRef];
//	CGImageRelease(subImageRef);
//    UIGraphicsEndImageContext();
//	
//	NSData *data = UIImageJPEGRepresentation(subImage,1.0);
//	return data;
}

+(UIImage *)rotateImage:(UIImage *)aImage

{
    
    CGImageRef imgRef = aImage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    UIImageOrientation orient = aImage.imageOrientation;
    switch(orient)
    
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            
            break;
            
        default:
            
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
        
    }
    
    else {
        
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
        
    }
    
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}


+ (UIImage*)thumbnailOfImage:(UIImage*)image
{
    UIImage *img = nil;
//    CGSize itemSize = CGSizeMake(170, 170);
    CGSize itemSize = CGSizeMake(340, 340);

    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [image drawInRect:imageRect];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	return img;
}


+ (UIImage*)thumbnailOfImage:(UIImage*)image height:(float)_height width:(float)_width
{
    UIImage *img = nil;
    CGSize itemSize = CGSizeMake(_width, _height);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [image drawInRect:imageRect];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	return img;
}


+ (UIImage*)thumbnailOfHeith:(UIImage*)image height:(float)_height
{
    UIImage *img = nil;
    float height = CGImageGetHeight(image.CGImage);
    float with = CGImageGetWidth(image.CGImage);
    
    float factor = _height/height;
    float drawWidth = with * factor;
    
    
    CGSize itemSize = CGSizeMake(drawWidth, _height);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [image drawInRect:imageRect];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	return img;
}

+ (UIImage*)thumbnailOfWidth:(UIImage*)image width:(float)_width
{
    UIImage *img = nil;
    float height = CGImageGetHeight(image.CGImage);
    float with = CGImageGetWidth(image.CGImage);
    
    float factor = _width/with;
    float drawHeight = height * factor;
    
    CGSize itemSize = CGSizeMake(_width, drawHeight);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [image drawInRect:imageRect];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	return img;
}

+(UIImage *)addBackgroundToImage:(UIImage *)image
{
	if (!image)
		return nil;
	CGImageRef imageRef = [image CGImage];
	UIImage *thumb = nil;
	//	struct CGSize imgSize = [imageRef size];
//	float _width = 240;
//	float _height = 190;
    float _width = 260;
	float _height = 214;
//    float _width = 130;
//	float _height = 107;
	// hardcode width and height for now, shouldn't stay like that
	CGContextRef bitmap = CGBitmapContextCreate(NULL,
												_width,
												_height,
												CGImageGetBitsPerComponent(imageRef),
												CGImageGetBitsPerPixel(imageRef)*_width,
                                                CGColorSpaceCreateDeviceRGB(),
												kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big
												);
	// now center the image
	
	//CGContextRotateCTM( bitmap, 180*(M_PI/180));
	CGContextDrawImage( bitmap, CGRectMake(0, 0, _width, _height), [UIImage imageNamed:@"GOVidePreBg.png"].CGImage);
	CGContextDrawImage( bitmap, CGRectMake(30, 20, 200, 174), imageRef );
    CGContextDrawImage( bitmap, CGRectMake(0, 0, _width, _height), [UIImage imageNamed:@"GOVieoPrePlayBg.png"].CGImage);
	// create a templete imageref.
	CGImageRef ref = CGBitmapContextCreateImage( bitmap );
	thumb = [UIImage imageWithCGImage:ref];
	
	// release the templete imageref.
	CGContextRelease( bitmap );
	CGImageRelease( ref );
	return thumb;
}


+ (UIImage  *)createThumbImage:(NSURL *)path
{
    AVURLAsset *asset2 = [AVURLAsset assetWithURL:path];
    CMTime duration = asset2.duration;
    float time = CMTimeGetSeconds(duration);
    
    CMTime startTime =  CMTimeMake(time/3, 1);
    CMTime endTime =  CMTimeMake(time/3, 1);
    
    AVAssetImageGenerator *assetImage = [[AVAssetImageGenerator alloc] initWithAsset:asset2];
    assetImage.apertureMode = AVAssetImageGeneratorApertureModeProductionAperture;
    CGImageRef imageRef = [assetImage copyCGImageAtTime:startTime actualTime:&endTime error:nil];
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:1.8 orientation:UIImageOrientationUp];
    return image;
    
}

+(UIImage *)getLocationImgFromImage:(UIImage *)img{
    
    float height = CGImageGetHeight(img.CGImage);
    float with = CGImageGetWidth(img.CGImage);
    
//    CGRect myImageRect = CGRectMake(with/2-180, height/2-100, 360, 200);
    CGRect myImageRect = CGRectMake(with/2-170, height/2-76, 340, 152);
    UIImage* bigImage= img;
    
    CGImageRef imageRef = bigImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    
    CGSize size;
    size.width = myImageRect.size.width;
    size.height = myImageRect.size.height;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}


+ (UIImage*)roundedRectWith:(float)radius cornerMask:(UIImageRoundedCorner)cornerMask image:(UIImage *)image
{
    UIImageView *bkImageViewTmp=[[UIImageView alloc]initWithImage:image];
    
    int w=image.size.width;
    int h=image.size.height;
    
    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
    CGContextRef context=CGBitmapContextCreate(NULL,w,h,8,4*w,colorSpace,kCGImageAlphaPremultipliedFirst);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context,bkImageViewTmp.frame,radius,cornerMask);
    CGContextClosePath(context);
    CGContextClip(context);
    
    CGContextDrawImage(context,CGRectMake(0,0,w,h),image.CGImage);
    
    CGImageRef imageMasked=CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIImage*newImage=[UIImage imageWithCGImage:imageMasked];
    
    CGImageRelease(imageMasked);
    
    return newImage;
}

+ (UIImage *)rotationImage:(UIImage *)image degree:(double)degree
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    rotate = degree * M_PI;
    rect = CGRectMake(0, 0, image.size.height, image.size.width);
    translateX = 0;
    translateY = -rect.size.width;
    scaleY = rect.size.width/rect.size.height;
    scaleX = rect.size.height/rect.size.width;
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};

+ (UIImage *)imageRotatedByImage:(UIImage *)image degrees:(CGFloat)degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height), [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

@end
