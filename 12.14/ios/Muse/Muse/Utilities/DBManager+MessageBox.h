//
//  DBManager+MessageBox.h
//  Muse
//
//  Created by paycloud110 on 16/8/15.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "DBManager.h"

@interface DBManager (MessageBox)

+ (NSString *)messageBoxTableName;
- (void)setupMessageBoxTable;

- (void)addOneMessageBoxContent:(NSDictionary<NSString *, NSString *> *)boxDict;
- (NSMutableArray *)readMessageBoxTableAllData;
- (void)cancelMessageBoxTableAllData;

@end
