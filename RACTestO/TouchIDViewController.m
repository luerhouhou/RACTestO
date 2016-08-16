//
//  TouchIDViewController.m
//  RACTestO
//
//  Created by zhanglu on 16/6/16.
//  Copyright © 2016年 zhanglu. All rights reserved.
//

#import "TouchIDViewController.h"
#import "EFSLogger.h"
@interface TouchIDViewController ()

@end

@implementation TouchIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSString *url = @"http://baidu.com";
    NSError *error = nil;
    NSDictionary *dict = @{};
//    EFSLog(url,dict,error);
    EFSLog(url, dict, error)
//    [[[EFSLogger alloc] init] logWithURLString:url params:dict error:error];
    DLog(@"3333===%@",@"22");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
