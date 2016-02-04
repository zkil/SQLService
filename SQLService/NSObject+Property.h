//
//  NSObject+Propertys.h
//  SQLService
//
//  Created by lee on 16/2/4.
//  Copyright © 2016年 sanchun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Property)
- (NSDictionary *)getAllPropertiesAndVaules;
-(NSArray *)getAllProperties;
-(void)getAllMethods;
@end
