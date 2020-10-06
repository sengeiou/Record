//
//  DeviceSelectionViewController.m
//  Muse
//
//  Created by Ken.Jiang on 16/7/23.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "DeviceSelectionViewController.h"
#import "BlueToothHelper.h"

@interface DeviceSelectionViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) CBPeripheral *selectedPeripheral;
@property (assign, nonatomic) NSInteger selectedRow;

@end

@implementation DeviceSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.tableFooterView = [UIView new];
    
    _selectedRow = -1;
    
    _titleLbl.text = NSLocalizedString(@"ProductListTitle", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

//- (IBAction)confirm:(id)sender {
//    if (_selectedPeripheral && _completionBlock) {
//        _completionBlock(_selectedPeripheral);
//    }
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

#pragma mark - Setter

- (void)setPeripherals:(NSArray *)peripherals {
    if ([_peripherals isEqualToArray:peripherals]) {
        return;
    }
    
    _peripherals = [NSArray arrayWithArray:peripherals];
    [_tableView reloadData];
    
    if (_selectedPeripheral) {
        BOOL find = NO;
        for (int i = 0; i < _peripherals.count; i++) {
            CBPeripheral *p = _peripherals[i];
            if ([p.identifier.UUIDString isEqualToString:_selectedPeripheral.identifier.UUIDString]) {
                _selectedPeripheral = p;
                _selectedRow = i;
                break;
            }
        }
        
        if (!find) {
            _selectedPeripheral = nil;
            _selectedRow = -1;
        }
    } else {
        _selectedRow = -1;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _peripherals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    CBPeripheral *peripheral = _peripherals[indexPath.row];
    cell.textLabel.text = peripheral.name;
    cell.detailTextLabel.text = peripheral.identifier.UUIDString;
    cell.accessoryType = _selectedRow == indexPath.row ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectedRow == indexPath.row) {
        return;
    }
    _selectedRow = indexPath.row;
    _selectedPeripheral = _peripherals[_selectedRow];
    [[BlueToothHelper sharedInstance] connectPeripheral:_selectedPeripheral
                                            deviceQurey:YES
                                             completion:nil];
    [tableView reloadData];
    
    if (_selectedPeripheral && _completionBlock) {
            _completionBlock(_selectedPeripheral);
        }
        
    [self dismissViewControllerAnimated:YES completion:nil];

}

@end
