//
//  SQLService.h
//  SQLService
//
//  Created by lee on 16/2/3.
//  Copyright © 2016年 sanchun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface SQLService : NSObject

+(sqlite3 *)openDB;
+(void)initTable;

+(NSString *)dataPath;

+(BOOL)createTableWithName:(NSString *)tableName field:(NSDictionary *)fieldDic;
+(void)addColumnWithTable:(NSString *)tableName field:(NSDictionary *)fieldDic;

+(BOOL)insertToTable:(NSString *)tableName  object:(id) object;
+(NSArray *)getTableData:(NSString *)tableName;
@end
