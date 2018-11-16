//
//  DemoTableViewController.m
//  LTxAuthorizationDemo
//
//  Created by liangtong on 2018/8/29.
//  Copyright © 2018年 LIANGTONG. All rights reserved.
//

#import "DemoTableViewController.h"
#import "LTxAuthorizationUI.h"
#import "LTxAuthorizationSippr.h"

@interface DemoTableViewController ()

@end

@implementation DemoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    UIViewController* nextVC;
    if ([cell.reuseIdentifier isEqualToString:@"common-login"]) {
        nextVC = [[LTxLoginViewController alloc] init];
    }else if ([cell.reuseIdentifier isEqualToString:@"common-validate"]) {
        nextVC = [[LTxLoginSmsValidateViewController alloc] init];
    }else if ([cell.reuseIdentifier isEqualToString:@"common-reset"]) {
        nextVC = [[LTxLoginChangePasswordViewController alloc] init];
    }else if ([cell.reuseIdentifier isEqualToString:@"eep-login"]) {
        nextVC = [[LTxLoginSipprViewController alloc] init];
    }else if ([cell.reuseIdentifier isEqualToString:@"eep-preloading"]) {
        
    }
    if (nextVC) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:nextVC animated:true];
        });
    }
}

@end
