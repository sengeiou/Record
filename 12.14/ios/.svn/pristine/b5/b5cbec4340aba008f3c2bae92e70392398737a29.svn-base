//
//  ClockView.m
//  Muse
//
//  Created by pg on 16/6/13.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "ClockView.h"
#import "ClockTableViewCell.h"

@implementation ClockView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - UITableViewDataSource UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewArr.count + 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ClockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClockTableViewCell"];
    if(!cell)
    {
        cell = [ClockTableViewCell cellFromNib];
    }
    
    
    return cell;
}

#pragma mark -- tableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
