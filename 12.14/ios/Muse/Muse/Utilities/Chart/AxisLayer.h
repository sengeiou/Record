//
//  AxisLayer.h
//  Chart
//
//  Created by Ken.Jiang on 20/4/2016.
//  Copyright © 2016 Ken.Jiang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIColor.h>

@interface AxisLayer : CALayer {
    CGColorRef _axisColor;
    CALayer *_axisLayer;
    
    CGColorRef _labelsColor;
    CGFloat _labelMargin;
    
    NSMutableArray<CALayer *> *_pointLayers;
    NSMutableSet<CALayer *> *_reusePointLayers;
    NSMutableArray<CATextLayer *> *_labelLayers;
    NSMutableSet<CATextLayer *> *_reuseLabelLayers;
    
    /**
     *  需要绘制坐标点的相对位置，值范围0～1
     */
    NSArray<NSNumber *> *_keyPoints;
    
    /**
     *  需要绘制坐标点的字符
     */
    NSArray<NSString *> *_keyLabels;
    
}

@property (assign, nonatomic) BOOL drawAxis;
@property (assign, nonatomic) BOOL drawLabels;

@property (strong, nonatomic) NSMutableArray<CALayer *> *pointLayers;
@property (strong, nonatomic) NSMutableSet<CALayer *> *reusePointLayers;

@property (assign, nonatomic) CGFloat labelFontSize;
@property (assign, nonatomic) CGFloat labelMargin;
@property (strong, nonatomic) NSMutableArray<CATextLayer *> *labelLayers;
@property (strong, nonatomic) NSMutableSet<CATextLayer *> *reuseLabelLayers;

/**
 *  坐标轴颜色，默认白色
 */
@property (assign, nonatomic) CGColorRef axisColor;

/**
 *  坐标值颜色，默认白色
 */
@property (assign, nonatomic) CGColorRef labelsColor;

- (CALayer *)dequeuePointLayer;
- (CATextLayer *)dequeueLabelLayer;


/**
 *  设置轴坐标显示信息（需要子类覆盖）
 *
 *  @param keyPoints keyPoints对应的相对位置值
 *  @param keyLabels keyPoints对应的label值
 */
- (void)setKeyPoints:(NSArray<NSNumber *> *)keyPoints withLabels:(NSArray<NSString *> *)keyLabels;

@end
