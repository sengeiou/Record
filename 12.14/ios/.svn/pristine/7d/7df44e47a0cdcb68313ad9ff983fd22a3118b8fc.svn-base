//
//  WSTableView.h
//  WSTableView
//
//  Created by Sakkaras on 26/12/13.
//  Copyright (c) 2013 Sakkaras. All rights reserved.
//

#import <TPKeyboardAvoiding/TPKeyboardAvoidingTableView.h>

NS_ASSUME_NONNULL_BEGIN

@class WSTableView;
@class WSTableViewCell;

#pragma mark - WSTableViewDelegate

@protocol WSTableViewDelegate <UITableViewDataSource, UITableViewDelegate>

@required
- (NSInteger)tableView:(WSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(WSTableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (CGFloat)tableView:(WSTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(WSTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableView:(WSTableView *)tableView shouldExpandSubRowsOfCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface WSTableView : TPKeyboardAvoidingTableView

@property (nonatomic, weak) id <WSTableViewDelegate> WSTableViewDelegate;
@property (nonatomic, assign) BOOL shouldExpandOnlyOneCell;

- (void)refreshData;
- (void)refreshDataWithScrollingToIndexPath:(NSIndexPath *)indexPath;
- (void)collapseCurrentlyExpandedIndexPaths;

- (nullable __kindof UITableViewCell *)cellForSubRowAtIndexPath:(NSIndexPath *)indexPath;   // returns nil if cell is not visible or index path is out of range

@end

#pragma mark - NSIndexPath (WSTableView)

@interface NSIndexPath (WSTableView)

@property (nonatomic, assign) NSInteger subRow;

+ (NSIndexPath *)indexPathForSubRow:(NSInteger)subrow inRow:(NSInteger)row inSection:(NSInteger)section;
- (NSIndexPath *)indexPathForSubRow:(NSInteger)subrow inRow:(NSInteger)row inSection:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
