//
//  PairPopView.m
//  Muse
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "PairPopView.h"
#import "PairPopTableViewCell.h"
#import "FriendList.h"
#import "AddressBookManager.h"

@interface PairPopView ()

@property (nonatomic,weak) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

@property (nonatomic,strong) NSMutableArray *tableViewArr;

@property (nonatomic,strong) UIViewController *fatherVC;

@property (nonatomic,strong) UIControl *overlayView;

@end

@implementation PairPopView

+ (PairPopView *)viewFromNibByVc:(UIViewController *)vc peopleArr:(NSMutableArray<AddressPerson *> *)peopleArr {
    
    PairPopView *pop;
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];//加载自定义cell的xib文件
    pop = [array objectAtIndex:0];
    pop.fatherVC = vc;
    pop.tableViewArr = peopleArr;
    
    pop.overlayView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height)];
    pop.overlayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    [pop.overlayView addTarget:pop
                    action:@selector(dismiss)
          forControlEvents:UIControlEventTouchUpInside];
    
    [pop addSubview:pop.overlayView];
    [pop sendSubviewToBack:pop.overlayView];
    
    [pop.overlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
    }];
    
    return pop;
}

- (void)dismiss {
    if(_completionBlock) {
        _completionBlock(_tableViewArr);
        _completionBlock = nil;
    }
    
    [self fadeOut];
}

- (void)show {
    [_fatherVC.view addSubview:self];
    self.tableView.layer.cornerRadius = 5;
    self.tableView.layer.masksToBounds = YES;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
    }];
    self.tableViewHeightConstraint.constant = [PairPopTableViewCell height] * MIN(self.tableViewArr.count, 5);
    [self fadeIn];
}

- (void)fadeIn {
    self.transform = CGAffineTransformMakeTranslation(0, 0);
    self.alpha = 0;
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.transform = CGAffineTransformIdentity;
                         self.alpha = 1;
                     }];
}

- (void)fadeOut {
    [UIView animateWithDuration:.25 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, 0);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - UITableViewDataSource UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PairPopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PairPopTableViewCell"];
    if(!cell) {
        cell = [PairPopTableViewCell cellFromNib];
    }
    
    AddressPerson *person = _tableViewArr[indexPath.row];
    cell.nameLB.text = person.name;
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(cell) weakCell = cell;
    cell.deleteBlock = ^() {
        NSIndexPath *indexPathDelete = [tableView indexPathForCell:weakCell];
        [weakSelf.tableViewArr removeObjectAtIndex:indexPathDelete.row];
        [weakSelf.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPathDelete] withRowAnimation:UITableViewRowAnimationFade];
        weakSelf.tableViewHeightConstraint.constant = [PairPopTableViewCell height] * MIN(weakSelf.tableViewArr.count, 5);
        
        if (weakSelf.tableViewArr.count == 0) {
            [weakSelf dismiss];
        }
    };
    
    return cell;
}

#pragma mark -- tableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
