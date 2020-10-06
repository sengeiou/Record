//
//  SleepGraphView.m
//  Muse
//
//  Created by apple on 16/6/2.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "SleepGraphView.h"

#import "UIColor+FastKit.h"

@implementation SleepGraphView {
    CGFloat _periodSum;
}

- (void)setGrapArr:(NSArray *)grapArr {
    if ([_grapArr isEqualToArray:grapArr]) {
        return;
    }
    
    _periodSum = 0;
    _grapArr = grapArr;
    for (NSDictionary *dic in _grapArr) {
        _periodSum += [dic[@"period"] floatValue];
    }
  
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    rect = CGRectMake(rect.origin.x, rect.origin.y + 19, width, height);
    
    CGFloat x = 0;
    for (int i = 0; i<_grapArr.count; i++) {
        NSDictionary *item = _grapArr[i];
        CGFloat itemWidth = [item[@"period"] floatValue] / _periodSum * width;
        rect = CGRectMake(x, rect.origin.y, itemWidth, height);
        
        switch ([item[@"type"] integerValue]) {
            case SleepGrapTypeDeep:
            {
                CGContextSetRGBFillColor(context, 29./255.,38./255.,68./255., 1.0);
                CGContextFillRect(context, rect);
            }
                break;
            case SleepGrapTypeShallow:
            {
                CGContextSetRGBFillColor(context, 44./255.,56./255.,96./255., 1.0);
                CGContextFillRect(context, rect);
            }
                break;
            case SleepGrapTypeWake:
            {
                CGContextSetRGBFillColor(context, 40./255.,119./255.,81./255., 1.0);
                CGContextFillRect(context, rect);
    
//                UIFont  *font = [UIFont boldSystemFontOfSize:12.0];
//                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//                paragraphStyle.lineBreakMode = NSLineBreakByTruncatingMiddle;
//                
//                NSDictionary *attributes = @{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle,NSForegroundColorAttributeName:[UIColor colorWithRed:152./255.0f green:152./255.0f blue:164./255.0f alpha:1.0f]};
//                
//                CGSize detailSize = [[NSString stringWithFormat:@"清醒%@",item[@"time"]] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15)
//                                                                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//                                                                                                 attributes:attributes
//                                                                                                    context:nil].size;
//                
//                [[NSString stringWithFormat:@"清醒%@",item[@"time"]] drawAtPoint:CGPointMake(x + [item[@"period"] floatValue]/2 - detailSize.width/2, 0) withAttributes:attributes];
            }
                break;
                
            default:
                break;
        }
        
        x += itemWidth;
    }
    
    CGContextStrokePath(context);
}


@end
