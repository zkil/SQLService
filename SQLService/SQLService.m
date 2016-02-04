//
//  SQLService.m
//  SQLService
//
//  Created by lee on 16/2/3.
//  Copyright © 2016年 sanchun. All rights reserved.
//
#import "SQLService.h"
#import "NSObject+Property.h"

#define DBNAME @"_sanchun_oa.db"


@implementation SQLService
+(sqlite3 *)openDB
{
    static dispatch_once_t once;
    sqlite3 *db = nil;
    NSString *path = [self dataPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL dbFlage = [fileManager fileExistsAtPath:path];
    
    if(!sqlite3_open([path UTF8String], &db) == SQLITE_OK)
    {
        NSLog(@"Error: open SQL");
    };
    
    dispatch_once(&once, ^{
        if (!dbFlage) {
            //第一次打开/创建数据库，创建新表
            [self initTable];
        }
    });
    return db;
}

+(NSString *)dataPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    return [documentPath stringByAppendingPathComponent:DBNAME];
}

#pragma -mark- 创建一个新表
//tableName表名 fieldDic字段字典  字段名为key 类型为value
+(BOOL)createTableWithName:(NSString *)tableName field:(NSDictionary *)fieldDic
{
    BOOL result = NO;
    if (fieldDic.count == 0) {
        return NO;
    }
    
    sqlite3 *db = [self openDB];
    NSArray *keys = [fieldDic allKeys];
    NSArray *types = [fieldDic allValues];
    NSMutableString *fieldStr = [NSMutableString new];
    for (int i = 0; i < fieldDic.count; i++) {
        [fieldStr appendFormat:@",%@ %@",keys[i],types[i]];
    }
    NSString *sqlStr = [NSString stringWithFormat:@"create table if not exists %@ (num INTEGER PRIMARY KEY AUTOINCREMENT%@)",tableName,fieldStr];
    
    if(sqlite3_exec(db, [sqlStr UTF8String], NULL, NULL, NULL)==SQLITE_OK)
    {
        result = YES;
    }
    else
    {
        NSLog(@"Error: failed to create Table %@ ",tableName);
    }
    sqlite3_close(db);
    return result;
}

// 初始化表格
+(void)initTable
{
    
}
#pragma -mark-给列表增加字段
+(void)addColumnWithTable:(NSString *)tableName field:(NSDictionary *)fieldDic
{
    
    if (fieldDic.count == 0) {
        return;
    }
    NSArray *keys = [fieldDic allKeys];
    NSArray *types = [fieldDic allValues];
    sqlite3 *db = [self openDB];
    for (int i = 0; i < fieldDic.count; i++) {
        
        NSString *sqlStr = [NSString stringWithFormat:@"alter table %@ add column '%@' %@",tableName,keys[i],types[i]];
        if(!sqlite3_exec(db, [sqlStr UTF8String], NULL, NULL, NULL) == SQLITE_OK)
        {
            NSLog(@"Error: add column %@ for table %@",keys[i],tableName);
        }
        
    }
    sqlite3_close(db);
}

+(BOOL)insertToTable:(NSString *)tableName object:(id)object
{
    BOOL result = YES;
    sqlite3 *db = [self openDB];
    
    NSDictionary *obj = [object getAllPropertiesAndVaules];
    NSArray *keys = [obj allKeys];
    NSArray *values = [obj allValues];
    NSMutableString *keysStr = [NSMutableString new];
    NSMutableString *valuesStr = [NSMutableString new];
    for (int i = 0; i < obj.count; i++) {
        NSString *key = keys[i];
        id value = values[i];
        if ([value isKindOfClass:[NSNumber class]]) {
            [keysStr appendFormat:@"%@,",key];
            [valuesStr appendFormat:@"%@,",value];
        }
        if ([value isKindOfClass:[NSString class]]) {
            [keysStr appendFormat:@"%@,",key];
            [valuesStr appendFormat:@"'%@',",value];
        }
    }
    if (obj.count != 0) {
        keysStr = (NSMutableString *)[keysStr substringToIndex:[keysStr length] - 1];
        valuesStr = (NSMutableString *)[valuesStr substringToIndex:[valuesStr length] - 1];
    }
    NSString *sqlStr = [NSString stringWithFormat:@"insert into %@(%@) values(%@)",tableName,keysStr,valuesStr];
    if (!sqlite3_exec(db, [sqlStr UTF8String], NULL, NULL, NULL) == SQLITE_OK) {
        result = NO;
        NSLog(@"ERROR: insert to table %@ with object %@",tableName,obj);
    }
    return result;
}
+(NSArray *)getTableData:(NSString *)tableName
{
    NSMutableArray *objects;
    
    
    return objects;
}
@end



