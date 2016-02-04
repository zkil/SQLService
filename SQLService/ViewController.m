//
//  ViewController.m
//  SQLService
//
//  Created by lee on 16/2/3.
//  Copyright © 2016年 sanchun. All rights reserved.
//

#import "ViewController.h"
#import <sqlite3.h>
#import "SQLService.h"
#import "NSObject+Property.h"
#import "NNNN.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"%@",[SQLService dataPath]);
    NNNN *n = [NNNN new];
    n.name = @"fff";
    n.age = 10;
    [SQLService createTableWithName:@"student" field:@{@"name":@"text",@"age":@"interger"}];
    [SQLService insertToTable:@"student" object:n];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
