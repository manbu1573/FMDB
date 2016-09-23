//
//  ViewController.m
//  FMDB-Demo
//
//  Created by 李荣建 on 16/9/9.
//  Copyright © 2016年 李荣建. All rights reserved.
//
#import "ViewController.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDBMigrationManager.h"
#import "Migration.h"
@interface ViewController ()
@property(nonatomic,strong)FMDatabase *db;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self FMDB];
}
-(void)FMDB{
    
    
    
    //1.获得数据库文件的路径
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    
    NSString *fileName = [doc stringByAppendingPathComponent:@"BOOK.sqlite"];
    
    
    
   //2.获得数据库
    
    self.db = [FMDatabase databaseWithPath:fileName];
    
    //3.使用如下语句，如果打开失败，可能是权限不足或者资源不足。通常打开完操作操作后，需要调用 close 方法来关闭数据库。在和数据库交互 之前，数据库必须是打开的。如果资源或权限不足无法打开或创建数据库，都会导致打开失败。
    if ([_db open])
    {
        //4.创表
        BOOL result = [_db executeUpdate:@"CREATE TABLE  if not exists book (id integer primary key autoincrement, bookNumber integer, bookName text, authorID integer, pressName text);"];
        if (result)
        {
            NSLog(@"创建表成功");
        }
    }
    
    
    FMDBMigrationManager *manager = [FMDBMigrationManager managerWithDatabaseAtPath:fileName  migrationsBundle:[NSBundle mainBundle]];
    Migration * migration_1=[[Migration alloc]initWithName:@"新增USer表" andVersion:1 andExecuteUpdateArray:@[@"CREATE TABLE  if not exists User (Name text, age integer)"]];
    Migration * migration_2=[[Migration alloc]initWithName:@"USer表新增字段email" andVersion:2 andExecuteUpdateArray:@[@"alter table User add email text"]];
    Migration * migration_3=[[Migration alloc]initWithName:@"USer表新增字段phone" andVersion:3 andExecuteUpdateArray:@[@"alter table User add phone text",@"alter table User add sex text"]];
//    Migration * migration_4=[[Migration alloc]initWithName:@"USer表新增字段phone" andVersion:4 andExecuteUpdateArray:@[]];
    
    [manager addMigration:migration_1];
    [manager addMigration:migration_2];
    [manager addMigration:migration_3];
//    [manager addMigration:migration_4];
    
    BOOL resultState=NO;
    NSError * error=nil;
    if (!manager.hasMigrationsTable) {
        resultState=[manager createMigrationsTable:&error];
    }

    resultState=[manager migrateDatabaseToVersion:UINT64_MAX progress:nil error:&error];
    [migration_1 migrateDatabase:self.db error:&error];
    [migration_2 migrateDatabase:self.db error:&error];
    [migration_3 migrateDatabase:self.db error:&error];
//    [migration_4 migrateDatabase:self.db error:&error];
    NSLog(@"Has `schema_migrations` table?: %@", manager.hasMigrationsTable ? @"YES" : @"NO");
    NSLog(@"Origin Version: %llu", manager.originVersion);
    NSLog(@"Current version: %llu", manager.currentVersion);
    NSLog(@"All migrations: %@", manager.migrations);
    NSLog(@"Applied versions: %@", manager.appliedVersions);
    NSLog(@"Pending versions: %@", manager.pendingVersions);
    
    
//    [self.db executeUpdateWithFormat:@"    insert into book (bookNumber, bookName, authorID, pressName) values (1002, '水浒传', 11, '黄河出版社');"];
//    [self.db executeUpdateWithFormat:@"    insert into book (bookNumber, bookName, authorID, pressName) values (1004, '红楼梦', 13, '武汉出版社');"];
//    [self.db executeUpdateWithFormat:@"        insert into book (bookNumber, bookName, authorID, pressName) values (1005, '琅琊榜', 14, '黄河出版社');"];
//    [self.db executeUpdateWithFormat:@"    insert into book (bookNumber, bookName, authorID, pressName) values (1006, '伪装者', 15, '长江出版社');"];
//    [self.db executeUpdateWithFormat:@"    insert into book (bookNumber, bookName, authorID, pressName) values (1007, '简爱', 16, '长江出版社');"];
    

    //加入新的选项
//    if (![_db columnExists:@"分数" inTableWithName:@"Student"]){
//        NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",@"Student",@"分数"];
//       BOOL worked = [_db executeUpdate:alertStr];
////        FMDBQuickCheck(worked);
//    }
//    
//    NSString *name = @"hh";
//    NSInteger age = 14;
    //插入
//    [self.db executeUpdateWithFormat:@"insert into Student (name,age) values (%@,%ld);",name,(long)age];
    //删除
//    [self.db executeUpdateWithFormat:@"delete from Student where name = %@;",@"hh"];
//更新
//    [self.db executeUpdate:@"update Student set name = ? where name = ?",@"lili",@"hh"];
    
//    FMResultSet *resultSet = [self.db executeQuery:@"select * from Student "];
//    while ([resultSet  next])
//        
//    {
//        int idNum = [resultSet intForColumn:@"id"];
//        
//        NSString *name = [resultSet objectForColumnName:@"name"];
//        
//        int age = [resultSet intForColumn:@"age"];
////        NSLog(@"%d,%@,%d",idNum,name,age);
//
//    }
    
//    if ([_db open])
//    {
//        //4.创表
//        BOOL result = [_db executeUpdate:@" create table if not exists author (id integer primary key autoincrement, authorName text, authorID integer, age integer);"];
//        
//        if (result)
//        {
//            NSLog(@"创建表成功");
//        }
//    }
    
   
        
//    [self.db executeUpdateWithFormat:@"insert into author (authorName, authorID, age) values ('jack', 21, 45);"];
//    [self.db executeUpdateWithFormat:@"insert into author (authorName, authorID, age) values ('dave', 10, 33);"];
//    [self.db executeUpdateWithFormat:@"    insert into author (authorName, authorID, age) values ('rose', 14, 24);"];
//    [self.db executeUpdateWithFormat:@"    insert into author (authorName, authorID, age) values ('jim', 16, 56);"];
//    [self.db executeUpdateWithFormat:@"    insert into author (authorName, authorID, age) values ('ivan', 13, 22);"];
    
//    [self.db executeUpdateWithFormat:@"delete from author"];
    
//    FMResultSet *result  = [self.db executeQuery:@"select author.authorName, book.bookName, book.pressName from author, book where author.authorID = book.authorID and age< (select avg(age) from author);"];
//    while ([result next]) {
//        NSLog(@"%@ ,%@, %@",[result objectForColumnName:@"authorName"],[result objectForColumnName:@"bookName"],[result objectForColumnName:@"pressName"] );
////        NSLog(@"%@",[result objectForColumnName:@"authorID"]);
//        
//    }
    
    [self.db close];
 
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
