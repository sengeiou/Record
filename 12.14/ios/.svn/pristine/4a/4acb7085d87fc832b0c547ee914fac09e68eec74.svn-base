//
//  BlueToothHelper.m
//  Muse
//
//  Created by apple on 16/6/26.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "BlueToothHelper.h"

#import <BabyBluetooth/BabyBluetooth.h>

#define channelOnPeropheralView @"84a58d28-713e-45ed-9d5e-27568d5b2a08"
#define channelOnCharacteristicView @"33836a55-2075-46d0-b778-ca37d18914b1"

@interface BlueToothHelper ()


@end

@implementation BlueToothHelper
{
    NSMutableArray *peripherals;
    NSMutableArray *peripheralsAD;
    NSMutableArray *descriptors;
    BabyBluetooth *baby;
    
}

+ (id)sharedInstance
{
    static BlueToothHelper *__singletion;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        __singletion=[[self alloc] init];
        
    });
    
    return __singletion;
}

- (void)startScan
{
    peripherals = [[NSMutableArray alloc]init];
    peripheralsAD = [[NSMutableArray alloc]init];
    //初始化BabyBluetooth 蓝牙库
    baby = [BabyBluetooth shareBabyBluetooth];
    //设置蓝牙委托
    [self babyDelegate];
    
    [baby cancelAllPeripheralsConnection];
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
    baby.scanForPeripherals().begin();
}

- (void)cancelScan
{
    [baby cancelScan];
}

-(void)babyDelegate{
    
    __weak typeof(self)myself = self;
    
    [baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            NSLog(@"设备打开成功，开始扫描设备");
        }
    }];
    
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
        
        if([peripheral.name isEqualToString:@"MuseHeart"])
        {
            [myself cancelScan];
            [myself babyConnect:peripheral];
        }
    }];
    
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *service in peripheral.services) {
            NSLog(@"搜索到服务:%@",service.UUID.UUIDString);
        }
        //找到cell并修改detaisText
        
    }];
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        for (CBCharacteristic *c in service.characteristics) {
            NSLog(@"charateristic name is :%@",c.UUID);
        }
    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    
    //设置查找设备的过滤器
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        
        //最常用的场景是查找某一个前缀开头的设备
        //        if ([peripheralName hasPrefix:@"Pxxxx"] ) {
        //            return YES;
        //        }
        //        return NO;
        
        //设置查找规则是名称大于0 ， the search rule is peripheral.name length > 0
        if (peripheralName.length >0) {
            return YES;
        }
        return NO;
    }];
    
    
    [baby setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelAllPeripheralsConnectionBlock");
    }];
    
    [baby setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelScanBlock");
    }];
    
    
    /*设置babyOptions
     
     参数分别使用在下面这几个地方，若不使用参数则传nil
     - [centralManager scanForPeripheralsWithServices:scanForPeripheralsWithServices options:scanForPeripheralsWithOptions];
     - [centralManager connectPeripheral:peripheral options:connectPeripheralWithOptions];
     - [peripheral discoverServices:discoverWithServices];
     - [peripheral discoverCharacteristics:discoverWithCharacteristics forService:service];
     
     该方法支持channel版本:
     [baby setBabyOptionsAtChannel:<#(NSString *)#> scanForPeripheralsWithOptions:<#(NSDictionary *)#> connectPeripheralWithOptions:<#(NSDictionary *)#> scanForPeripheralsWithServices:<#(NSArray *)#> discoverWithServices:<#(NSArray *)#> discoverWithCharacteristics:<#(NSArray *)#>]
     */
    
    //示例:
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    //连接设备->
    [baby setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
    
}

- (void)babyConnect:(CBPeripheral *)currPeripheral
{
    BabyRhythm *rhythm = [[BabyRhythm alloc]init];
    
    __weak typeof(self)myself = self;
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    [baby setBlockOnConnectedAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"设备：%@--连接成功",peripheral.name);
    }];
    
    //设置设备连接失败的委托
    [baby setBlockOnFailToConnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--连接失败",peripheral.name);
    }];
    
    //设置设备断开连接的委托
    [baby setBlockOnDisconnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--断开连接",peripheral.name);
    }];
    
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServicesAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *s in peripheral.services) {
            ///插入section到tableview
            //            [weakSelf insertSectionToTableView:s];
        }
        
        [rhythm beats];
    }];
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristicsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        //插入row到tableview
        //        [weakSelf insertRowToTableView:service];
        [service.characteristics enumerateObjectsUsingBlock:^(CBCharacteristic * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([channelOnCharacteristicView isEqualToString: [[obj.UUID UUIDString] lowercaseString]])
            {
                
                [myself lastConnect:peripheral Characteristic:obj];
            }
        }];
        
    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptorsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    //读取rssi的委托
    [baby setBlockOnDidReadRSSI:^(NSNumber *RSSI, NSError *error) {
        NSLog(@"setBlockOnDidReadRSSI:RSSI:%@",RSSI);
    }];
    
    
    //设置beats break委托
    [rhythm setBlockOnBeatsBreak:^(BabyRhythm *bry) {
        NSLog(@"setBlockOnBeatsBreak call");
        
        //如果完成任务，即可停止beat,返回bry可以省去使用weak rhythm的麻烦
        //        if (<#condition#>) {
        //            [bry beatsOver];
        //        }
        
    }];
    
    //设置beats over委托
    [rhythm setBlockOnBeatsOver:^(BabyRhythm *bry) {
        NSLog(@"setBlockOnBeatsOver call");
    }];
    
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    /*连接选项->
     CBConnectPeripheralOptionNotifyOnConnectionKey :当应用挂起时，如果有一个连接成功时，如果我们想要系统为指定的peripheral显示一个提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnDisconnectionKey :当应用挂起时，如果连接断开时，如果我们想要系统为指定的peripheral显示一个断开连接的提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnNotificationKey:
     当应用挂起时，使用该key值表示只要接收到给定peripheral端的通知就显示一个提
     */
    NSDictionary *connectOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnNotificationKey:@YES};
    
    [baby setBabyOptionsAtChannel:channelOnPeropheralView scanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:connectOptions scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
    baby.having(currPeripheral).and.channel(channelOnPeropheralView).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
}

- (void)lastConnect:(CBPeripheral *)currPeripheral  Characteristic:(CBCharacteristic *)characteristic
{
    
    descriptors = [[NSMutableArray alloc]init];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"CharacteristicViewController===characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        //        NSLog(@"CharacteristicViewController===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CharacteristicViewController CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptorsAtChannel:channelOnCharacteristicView block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        for (int i =0 ; i<descriptors.count; i++) {
            if (descriptors[i]==descriptor) {
                
            }
        }
        NSLog(@"CharacteristicViewController Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    //设置写数据成功的block
    [baby setBlockOnDidWriteValueForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"setBlockOnDidWriteValueForCharacteristicAtChannel characteristic:%@ and new value:%@",characteristic.UUID, characteristic.value);
    }];
    
    //设置通知状态改变的block
    [baby setBlockOnDidUpdateNotificationStateForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"uid:%@,isNotifying:%@",characteristic.UUID,characteristic.isNotifying?@"on":@"off");
    }];
    
    baby.channel(channelOnCharacteristicView).characteristicDetails(currPeripheral,characteristic);
    
    [self writeValue:currPeripheral Characteristic:characteristic];
    
    [self setNotifiy:currPeripheral Characteristic:characteristic];
}


-(void)writeValue:(CBPeripheral *)currPeripheral Characteristic:(CBCharacteristic *)characteristic{
    //    int i = 1;
    Byte b = 0x53;
    NSData *data = [NSData dataWithBytes:&b length:sizeof(b)];
    [currPeripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    
    if(self.successBlock)
    {
        
        self.successBlock(@"cc");
    }
}

-(void)setNotifiy:(CBPeripheral *)currPeripheral Characteristic:(CBCharacteristic *)characteristic{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    __weak typeof(self)weakSelf = self;
    if(currPeripheral.state != CBPeripheralStateConnected) {
        NSLog(@"peripheral已经断开连接，请重新连接");
        return;
    }
    if (characteristic.properties & CBCharacteristicPropertyNotify ||  characteristic.properties & CBCharacteristicPropertyIndicate) {
        
        if(characteristic.isNotifying) {
            [baby cancelNotify:currPeripheral characteristic:characteristic];
        }else{
            [currPeripheral setNotifyValue:YES forCharacteristic:characteristic];
            [baby notify:currPeripheral
          characteristic:characteristic
                   block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                       NSLog(@"---%@",characteristics.value);
                       
                       NSLog(@"notify block");
                       NSString *string1=[NSString stringWithFormat:@"%@",characteristic.value];
                       if (string1.length>4) {
                           NSString *string2=[string1 substringWithRange:NSMakeRange(3, 2)];
                           
                           NSString * temp10 = [NSString stringWithFormat:@"%lu",strtoul([string2 UTF8String],0,16)];
                           NSLog(@"心跳数字 10进制 %@",temp10);
                           //转成数字
                           // int cycleNumber = [temp10 intValue];
                           // NSLog(@"心跳数字 ：%d",cycleNumber);
                           
                           if (temp10.length==1) {
                               [userDefaults setObject:[NSString stringWithFormat:@"00%@",temp10] forKey:@"xinlv"];
                           }
                           
                           if (temp10.length==2) {
                               [userDefaults setObject:[NSString stringWithFormat:@"0%@",temp10] forKey:@"xinlv"];
                           }
                           if (temp10.length==3) {
                               [userDefaults setObject:[NSString stringWithFormat:@"%@",temp10] forKey:@"xinlv"];
                           }
                           NSLog(@"---%@",[userDefaults objectForKey:@"xinlv"]);
                       }
                       
                       
                   }];
        }
    }
    else{
        NSLog(@"这个characteristic没有nofity的权限");
        return;
    }
    
}/*
  + (NSString *)stringFromHexString:(NSString *)hexString {
  
  char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
  bzero(myBuffer, [hexString length] / 2 + 1);
  for (int i = 0; i < [hexString length] - 1; i += 2) {
  unsigned int anInt;
  NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
  NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
  [scanner scanHexInt:&anInt];
  myBuffer[i / 2] = (char)anInt;
  }
  NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
  NSLog(@"------字符串=======%@",unicodeString);
  return unicodeString;
  
  
  }
  */
@end
