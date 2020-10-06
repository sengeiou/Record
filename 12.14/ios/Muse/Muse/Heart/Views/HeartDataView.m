//
//  HeartDataView.m
//  Muse
//
//  Created by Ken.Jiang on 1/6/2016.
//  Copyright © 2016 Muse. All rights reserved.
//

#import "HeartDataView.h"
#import "HeartSingleDataView.h"

@interface HeartDataView () {
    NSMutableSet *_dequeuedSingleDataViews;
    HeartSingleDataView *_currentSingleDataView;
    
    BOOL _animating;
}

@property (weak, nonatomic) IBOutlet UIView *singleDataViewContainer;

@end

@implementation HeartDataView

+ (instancetype)viewFromNib {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"HeartDataView" owner:self options:nil] lastObject];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    _chartContainer.bounceDistance = 0.5f;
    _chartContainer.decelerationRate = 0.5f;
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUpAction:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.singleDataViewContainer addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDownAction:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.singleDataViewContainer addGestureRecognizer:swipeDown];
    
    _dequeuedSingleDataViews = [NSMutableSet set];
}

#pragma mark - Actions

- (void)animateSingleDataViewDirectionUp:(BOOL)directionUp {
    if ([_dataSource respondsToSelector:@selector(heartDataViewScrollUp:)]) {
        NSDictionary *data = [_dataSource heartDataViewScrollUp:directionUp];
        
        if (!data) {
            return;
        }
        
        NSString *heartRate = data[@"HeartRate"];
        if ([heartRate integerValue] == 0) {
            heartRate = _currentSingleDataView.heartRateLabel.text;
        }
        
        [self removeSingleDataView:_currentSingleDataView withDirectionUp:directionUp];
        _currentSingleDataView = [self addSingleDataViewWithDirectionUp:directionUp];
        [self setDate:data[@"Date"] heartRate:data[@"HeartRate"]];
    }
}

- (void)swipeUpAction:(id)sender {
    if (_animating) {
        return;
    }
    
    [self animateSingleDataViewDirectionUp:YES];
}

- (void)swipeDownAction:(id)sender {
    if (_animating) {
        return;
    }
    
    [self animateSingleDataViewDirectionUp:NO];
}

#pragma mark - Private

- (HeartSingleDataView *)dequeueSingleDataView {
    HeartSingleDataView *view = [_dequeuedSingleDataViews anyObject];
    if (!view) {
        view = [HeartSingleDataView viewFromNib];
        view.frame = _singleDataViewContainer.bounds;
    }
    [_singleDataViewContainer addSubview:view];
    [_dequeuedSingleDataViews removeObject:view];
    
    return view;
}

- (void)queueSingleDataView:(HeartSingleDataView *)view {
    [view removeFromSuperview];
    [_dequeuedSingleDataViews addObject:view];
}

- (HeartSingleDataView *)addSingleDataViewWithDirectionUp:(BOOL)up {
    
    _animating = YES;
    
    HeartSingleDataView *view = [self dequeueSingleDataView];
    
    CGRect frame = _singleDataViewContainer.bounds;
    if (up) {
        frame.origin = CGPointMake(0, frame.size.height);
    } else {
        frame.origin = CGPointMake(0, -frame.size.height);
    }
    view.frame = frame;
    
    frame = _singleDataViewContainer.bounds;
    [UIView animateWithDuration:0.25 animations:^{
        view.frame = frame;
    } completion:^(BOOL finished) {
        _animating = NO;
    }];
    
    return view;
}

- (void)removeSingleDataView:(HeartSingleDataView *)view withDirectionUp:(BOOL)up {
    _animating = YES;
    
    CGRect frame = _singleDataViewContainer.bounds;
    if (up) {
        frame.origin = CGPointMake(0, -frame.size.height);
    } else {
        frame.origin = CGPointMake(0, frame.size.height);
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        view.frame = frame;
    } completion:^(BOOL finished) {
        [self queueSingleDataView:view];
        
        _animating = NO;
    }];
}

#pragma mark - Public

- (void)setDate:(NSString *)date heartRate:(NSString *)heartRate {
    
    if (!_currentSingleDataView) {
        _currentSingleDataView = [self dequeueSingleDataView];
    }
    
    [_currentSingleDataView setDate:date heartRate:heartRate];
}


@end
