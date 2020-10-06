//
//  WSTableView.m
//  WSTableView
//
//  Created by Sakkaras on 26/12/13.
//  Copyright (c) 2013 Sakkaras. All rights reserved.
//

#import "WSTableView.h"
#import "WSTableViewCell.h"
#import <objc/runtime.h>

static NSString * const kIsExpandedKey = @"isExpanded";
static NSString * const kSubrowsKey = @"subrowsCount";
CGFloat const kDefaultCellHeight = 44.0f;

#pragma mark - WSTableView

@interface WSTableView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSMutableDictionary *expandableCells;

@end

@implementation WSTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _shouldExpandOnlyOneCell = NO;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        _shouldExpandOnlyOneCell = NO;
    }
    
    return self;
}

- (void)setWSTableViewDelegate:(id<WSTableViewDelegate>)WSTableViewDelegate
{
    self.dataSource = self;
    self.delegate = self;
    
    [self setSeparatorColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
    
    if (WSTableViewDelegate)
        _WSTableViewDelegate = WSTableViewDelegate;
}

- (void)setSeparatorColor:(UIColor *)separatorColor
{
    [super setSeparatorColor:separatorColor];
}

- (NSMutableDictionary *)expandableCells
{
    if (!_expandableCells) {
        _expandableCells = [NSMutableDictionary dictionary];
        NSInteger numberOfSections = [self.WSTableViewDelegate numberOfSectionsInTableView:self];
        for (NSInteger section = 0; section < numberOfSections; section++) {
            NSInteger numberOfRowsInSection = [self.WSTableViewDelegate tableView:self
                                                             numberOfRowsInSection:section];
            NSMutableArray *rows = [NSMutableArray array];
            for (NSInteger row = 0; row < numberOfRowsInSection; row++) {
                NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
                NSInteger numberOfSubrows = [self.WSTableViewDelegate tableView:self
                                                      numberOfSubRowsAtIndexPath:rowIndexPath];
                BOOL isExpandedInitially = NO;
                if ([self.WSTableViewDelegate respondsToSelector:@selector(tableView:shouldExpandSubRowsOfCellAtIndexPath:)]) {
                    isExpandedInitially = [self.WSTableViewDelegate tableView:self shouldExpandSubRowsOfCellAtIndexPath:rowIndexPath];
                }
                NSMutableDictionary *rowInfo = [NSMutableDictionary dictionaryWithObjects:@[@(isExpandedInitially), @(numberOfSubrows)]
                                                                                  forKeys:@[kIsExpandedKey, kSubrowsKey]];

                [rows addObject:rowInfo];
            }
            [_expandableCells setObject:rows forKey:@(section)];
        }
    }
    return _expandableCells;
}

- (void)refreshData {
    self.expandableCells = nil;
    
    [super reloadData];
}

- (void)refreshDataWithScrollingToIndexPath:(NSIndexPath *)indexPath {
    [self refreshData];
    
    if (indexPath.section < [self numberOfSections] && indexPath.row < [self numberOfRowsInSection:indexPath.section])
    {
        [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark - UITableViewDataSource

#pragma mark - Required

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_WSTableViewDelegate tableView:tableView numberOfRowsInSection:section] + [self numberOfExpandedSubrowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *correspondingIndexPath = [self correspondingIndexPathForRowAtIndexPath:indexPath];
    if ([correspondingIndexPath subRow] == 0) {
        WSTableViewCell *expandableCell = (WSTableViewCell *)[_WSTableViewDelegate tableView:tableView cellForRowAtIndexPath:correspondingIndexPath];
        if ([expandableCell respondsToSelector:@selector(setSeparatorInset:)]) {
            expandableCell.separatorInset = UIEdgeInsetsZero;
        }
        
        BOOL isExpanded = [self.expandableCells[@(correspondingIndexPath.section)][correspondingIndexPath.row][kIsExpandedKey] boolValue];
        if (expandableCell.isExpandable)
        {
            expandableCell.expanded = isExpanded;
            
            UIButton *expandableButton = (UIButton *)expandableCell.accessoryView;
            [expandableButton addTarget:tableView
                                 action:@selector(expandableButtonTouched:event:)
                       forControlEvents:UIControlEventTouchUpInside];
            
            if (isExpanded)
            {
                expandableCell.accessoryView.transform = CGAffineTransformMakeRotation(M_PI);
            }
        }
        else
        {
            expandableCell.expanded = NO;
            expandableCell.accessoryView = nil;
        }
       return expandableCell;
    }
    else
    {
        correspondingIndexPath = [NSIndexPath indexPathForSubRow:correspondingIndexPath.subRow-1
                                                           inRow:correspondingIndexPath.row
                                                       inSection:correspondingIndexPath.section];
        UITableViewCell *cell = [_WSTableViewDelegate tableView:(WSTableView *)tableView cellForSubRowAtIndexPath:correspondingIndexPath];
        cell.backgroundColor = [self separatorColor];
        cell.backgroundView = nil;
        cell.indentationLevel = 2;
        
        return cell;
    }
}

#pragma mark - Optional

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_WSTableViewDelegate respondsToSelector:@selector(numberOfSectionsInTableView:)])
    {
        return [_WSTableViewDelegate numberOfSectionsInTableView:tableView];
    }
    
    return 1;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_WSTableViewDelegate respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
        [_WSTableViewDelegate tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_WSTableViewDelegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)]) {
        return [_WSTableViewDelegate tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    }else {
        return @"del";
    }
}
#pragma mark - Optional

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WSTableViewCell *cell = (WSTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell respondsToSelector:@selector(isExpandable)])
    {
        if (cell.isExpandable)
        {
            cell.expanded = !cell.isExpanded;
        
            NSIndexPath *_indexPath = indexPath;
            NSIndexPath *correspondingIndexPath = [self correspondingIndexPathForRowAtIndexPath:indexPath];
            if (cell.isExpanded && _shouldExpandOnlyOneCell)
            {
                _indexPath = correspondingIndexPath;
                [self collapseCurrentlyExpandedIndexPaths];
            }
        
            if (_indexPath)
            {
                NSInteger numberOfSubRows = [self numberOfSubRowsAtIndexPath:correspondingIndexPath];
            
                NSMutableArray *expandedIndexPaths = [NSMutableArray array];
                NSInteger row = _indexPath.row;
                NSInteger section = _indexPath.section;
            
                for (NSInteger index = 1; index <= numberOfSubRows; index++)
                {
                    NSIndexPath *expIndexPath = [NSIndexPath indexPathForRow:row+index inSection:section];
                    [expandedIndexPaths addObject:expIndexPath];
                }
            
                if (cell.isExpanded)
                {
                    [self setExpanded:YES forCellAtIndexPath:correspondingIndexPath];
                    [self insertRowsAtIndexPaths:expandedIndexPaths withRowAnimation:UITableViewRowAnimationTop];
                }
                else
                {
                    [self setExpanded:NO forCellAtIndexPath:correspondingIndexPath];
                    [self deleteRowsAtIndexPaths:expandedIndexPaths withRowAnimation:UITableViewRowAnimationTop];
                }
            }
        }
        
        if ([_WSTableViewDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
        {
            NSIndexPath *correspondingIndexPath = [self correspondingIndexPathForRowAtIndexPath:indexPath];
            
            if (correspondingIndexPath.subRow == 0)
            {
                if ([_WSTableViewDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
                    [_WSTableViewDelegate tableView:self didSelectRowAtIndexPath:correspondingIndexPath];
                }
            }
            else
            {
                correspondingIndexPath = [NSIndexPath indexPathForSubRow:correspondingIndexPath.subRow-1
                                                                   inRow:correspondingIndexPath.row
                                                               inSection:correspondingIndexPath.section];
                if ([_WSTableViewDelegate respondsToSelector:@selector(tableView:didSelectSubRowAtIndexPath:)]) {
                    [_WSTableViewDelegate tableView:self didSelectSubRowAtIndexPath:correspondingIndexPath];
                }
            }
        }
    }
    else
    {
        if ([_WSTableViewDelegate respondsToSelector:@selector(tableView:didSelectSubRowAtIndexPath:)])
        {
            NSIndexPath *correspondingIndexPath = [self correspondingIndexPathForRowAtIndexPath:indexPath];
            correspondingIndexPath = [NSIndexPath indexPathForSubRow:correspondingIndexPath.subRow-1
                                                               inRow:correspondingIndexPath.row
                                                           inSection:correspondingIndexPath.section];
            [_WSTableViewDelegate tableView:self didSelectSubRowAtIndexPath:correspondingIndexPath];
        }
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if ([_WSTableViewDelegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)])
        [_WSTableViewDelegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    
    [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *correspondingIndexPath = [self correspondingIndexPathForRowAtIndexPath:indexPath];
    if ([correspondingIndexPath subRow] == 0)
    {
        if ([_WSTableViewDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
        {
            return [_WSTableViewDelegate tableView:tableView heightForRowAtIndexPath:correspondingIndexPath];
        }
        
        return kDefaultCellHeight;
    }
    else
    {
        if ([_WSTableViewDelegate respondsToSelector:@selector(tableView:heightForSubRowAtIndexPath:)])
        {
            NSIndexPath *correspondingIndexPath = [self correspondingIndexPathForRowAtIndexPath:indexPath];
            correspondingIndexPath = [NSIndexPath indexPathForSubRow:correspondingIndexPath.subRow-1
                                                               inRow:correspondingIndexPath.row
                                                           inSection:correspondingIndexPath.section];
            return [_WSTableViewDelegate tableView:self heightForSubRowAtIndexPath:correspondingIndexPath];
        }
        
        return kDefaultCellHeight;
    }
}
//
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([_WSTableViewDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)])
    {
       return [_WSTableViewDelegate tableView:tableView heightForHeaderInSection:section];

    }
    
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([_WSTableViewDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]){
       return  [_WSTableViewDelegate tableView:tableView heightForFooterInSection:section];
    }
    
    
    return 0.1f;
}
#pragma mark - WSTableViewUtils

- (NSInteger)numberOfExpandedSubrowsInSection:(NSInteger)section
{
    NSInteger totalExpandedSubrows = 0;
    
    NSArray *rows = self.expandableCells[@(section)];
    for (id row in rows)
    {
        if ([row[kIsExpandedKey] boolValue] == YES)
        {
            totalExpandedSubrows += [row[kSubrowsKey] integerValue];
        }
    }
    
    return totalExpandedSubrows;
}

- (IBAction)expandableButtonTouched:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self];
    
    NSIndexPath *indexPath = [self indexPathForRowAtPoint:currentTouchPosition];
    
    if (indexPath)
        [self tableView:self accessoryButtonTappedForRowWithIndexPath:indexPath];
}

- (NSInteger)numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    return [_WSTableViewDelegate tableView:self numberOfSubRowsAtIndexPath:indexPath];
}

- (NSIndexPath *)correspondingIndexPathForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __block NSIndexPath *correspondingIndexPath = nil;
    __block NSInteger expandedSubrows = 0;
    NSArray *rows = self.expandableCells[@(indexPath.section)];
    [rows enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

        BOOL isExpanded = [obj[kIsExpandedKey] boolValue];
        NSInteger numberOfSubrows = 0;
        if (isExpanded) {
            numberOfSubrows = [obj[kSubrowsKey] integerValue];
        }
        NSInteger subrow = indexPath.row - expandedSubrows - idx;
        if (subrow > numberOfSubrows) {
            expandedSubrows += numberOfSubrows;
        }else {
             correspondingIndexPath = [NSIndexPath indexPathForSubRow:subrow
                                                                inRow:idx
                                                            inSection:indexPath.section];
            *stop = YES;
        }
    }];
    return correspondingIndexPath;
}

- (void)setExpanded:(BOOL)isExpanded forCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *cellInfo = self.expandableCells[@(indexPath.section)][indexPath.row];
    [cellInfo setObject:@(isExpanded) forKey:kIsExpandedKey];
}

- (void)collapseCurrentlyExpandedIndexPaths
{
    NSMutableArray *totalExpandedIndexPaths = [NSMutableArray array];
    NSMutableArray *totalExpandableIndexPaths = [NSMutableArray array];
    
    [self.expandableCells enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
       
        __block NSInteger totalExpandedSubrows = 0;
        
        [obj enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           
            NSInteger currentRow = idx + totalExpandedSubrows;
            
            BOOL isExpanded = [obj[kIsExpandedKey] boolValue];
            if (isExpanded)
            {
                NSInteger expandedSubrows = [obj[kSubrowsKey] integerValue];
                for (NSInteger index = 1; index <= expandedSubrows; index++)
                {
                    NSIndexPath *expandedIndexPath = [NSIndexPath indexPathForRow:currentRow + index
                                                                        inSection:[key integerValue]];
                    [totalExpandedIndexPaths addObject:expandedIndexPath];
                }
                
                [obj setObject:@(NO) forKey:kIsExpandedKey];
                totalExpandedSubrows += expandedSubrows;
                
                [totalExpandableIndexPaths addObject:[NSIndexPath indexPathForRow:currentRow inSection:[key integerValue]]];
            }
        }];
    }];
    for (NSIndexPath *indexPath in totalExpandableIndexPaths) {
        WSTableViewCell *cell = (WSTableViewCell *)[self cellForRowAtIndexPath:indexPath];
        cell.expanded = NO;
    }
    
    [self deleteRowsAtIndexPaths:totalExpandedIndexPaths withRowAnimation:UITableViewRowAnimationTop];
}
- (UITableViewCell *)cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *subIndexPath = [NSIndexPath indexPathForSubRow:indexPath.subRow inRow:indexPath.row inSection:indexPath.section];
    return [_WSTableViewDelegate tableView:self cellForSubRowAtIndexPath:subIndexPath];;
}

@end

#pragma mark - NSIndexPath (WSTableView)

static void *SubRowObjectKey;

@implementation NSIndexPath (WSTableView)

@dynamic subRow;

- (NSInteger)subRow
{
    id subRowObj = objc_getAssociatedObject(self, SubRowObjectKey);
    return [subRowObj integerValue];
}

- (void)setSubRow:(NSInteger)subRow
{
    id subRowObj = [NSNumber numberWithInteger:subRow];
    objc_setAssociatedObject(self, SubRowObjectKey, subRowObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSIndexPath *)indexPathForSubRow:(NSInteger)subrow inRow:(NSInteger)row inSection:(NSInteger)section
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    indexPath.subRow = subrow;
    return indexPath;
}
- (NSIndexPath *)indexPathForSubRow:(NSInteger)subrow inRow:(NSInteger)row inSection:(NSInteger)section
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    indexPath.subRow = subrow;
    return indexPath;
}


@end

