//
//  Migration.h
//  FMDB-Demo
//
//  Created by 李荣建 on 16/9/18.
//  Copyright © 2016年 李荣建. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "FMDBMigrationManager.h"

@interface Migration : NSObject<FMDBMigrating>

- (instancetype)initWithName:(NSString *)name andVersion:(uint64_t)version andExecuteUpdateArray:(NSArray *)updateArray;//自定义方法

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) uint64_t version;
- (BOOL)migrateDatabase:(FMDatabase *)database error:(out NSError *__autoreleasing *)error;


@end