//
//  HomeViewTableViewCell.m
//  Muse
//
//  Created by pg on 16/5/13.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "HomeViewTableViewCell.h"
#import "UIView+FastKit.h"
#import <Masonry/Masonry.h>

@implementation HomeViewTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellFromNib {
    HomeViewTableViewCell *cell;
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];//加载自定义cell的xib文件
    cell = [array objectAtIndex:0];
    return cell;
}

#pragma mark - Override

- (void)updateConstraints {
    [super updateConstraints];
    
    for (NSLayoutConstraint *con in self.dataLB.constraints) {
        if (con.firstItem == self.dataLB && con.firstAttribute == NSLayoutAttributeWidth) {
            con.constant = self.dataLB.myContentSize.width;
        } else if (con.firstItem == self.dataLB && con.firstAttribute == NSLayoutAttributeHeight) {
            con.constant = self.dataLB.myContentSize.height;
        }
    }
}

#pragma mark - Privates

- (void)setImageView:(UIImageView *)imageView withImageName:(NSString *)imageName {
    if (imageName) {
        imageView.image = [UIImage imageNamed:imageName];
    } else {
        imageView.image = nil;
    }
}

#pragma mark - Getter

- (DoubleProgressView *)progressView {
    if(!_progressView) {
        _progressView = [[DoubleProgressView alloc]initWithFrame:self.bgIMV.frame];
    
        _progressView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, self.height/2);
        [self.contentView addSubview:_progressView];
        
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_bgIMV);
        }];
    }
    
    return _progressView;
}

#pragma mark - Setter

- (void)setCellData:(NSDictionary *)cellData {
    if ([_cellData isEqualToDictionary:cellData]) {
        return;
    }
    
    _cellData = cellData;
    
    [self setImageView:_typeTopIMV withImageName:cellData[@"top_image"]];
    [self setImageView:_unitIMV withImageName:cellData[@"unit"]];
    [self setImageView:_typeBottomIMV withImageName:cellData[@"bottom_image"]];
        
    self.bottomLB.text = cellData[@"bottomContent"];
    [self.progressView setOuterProgress:[cellData[@"progess"] floatValue] animated:YES];
    if(cellData[@"dataNum"])
        self.dataLB.num = cellData[@"dataNum"];
    else
        self.dataLB.num = @"000";
    
    MSLog(@"%@",self.dataLB.num);
    for (NSLayoutConstraint *con in self.dataLB.constraints) {
        if(con.firstItem == self.dataLB && con.firstAttribute == NSLayoutAttributeWidth) {
            con.constant = self.dataLB.myContentSize.width;
        } else if(con.firstItem == self.dataLB && con.firstAttribute == NSLayoutAttributeHeight) {
            con.constant = self.dataLB.myContentSize.height;
        }
    }
}

#pragma mark - Public

- (void)hideDetailViews:(BOOL)hide {
    
    self.typeTopIMV.hidden = hide;
    self.dataLB.hidden = hide;
    self.unitIMV.hidden = hide;
    self.typeBottomIMV.hidden = hide;
    self.bottomLB.hidden = hide;
}

- (void)startHeartRipple {
    
    if (_rippleView.animationImages.count == 0) {
        NSMutableArray *images = [NSMutableArray array];
        for (int i = 1; i < 13; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"btn_heartrate_heart_%d", i]];
            [images addObject:image];
        }
        
        _rippleView.animationImages = images;
        _rippleView.animationDuration = 2.5f;
    }
    
    [self hideDetailViews:YES];
    self.rippleView.hidden = NO;
    
    [_rippleView startAnimating];
}

- (void)stopHeartRipple {
    
    [_rippleView stopAnimating];
    
    self.rippleView.hidden = YES;
    
    [self hideDetailViews:NO];
}

@end
