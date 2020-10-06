//
//  DeviceSelectionViewController.h
//  Muse
//
//  Created by Ken.Jiang on 16/7/23.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MSViewController.h"

@class CBPeripheral;

@interface DeviceSelectionViewController : MSViewController

@property (strong, nonatomic) NSArray *peripherals;

@property (nonatomic,copy) void (^completionBlock)(CBPeripheral *selectedPeripheral);

@property IBOutlet UILabel *titleLbl;

@end
