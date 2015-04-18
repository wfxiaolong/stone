//
//  RWRCChatViewController.m
//  Stone
//
//  Created by linxiaolong on 15/2/10.
//  Copyright (c) 2015年 xlong. All rights reserved.
//

#import "RWRCChatViewController.h"
#import "FriendViewController.h"

@interface RWRCChatViewController () <RCSendMessageDelegate>

@end

@implementation RWRCChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.enableSettings = NO;
    self.enablePOI = NO;
    self.enableVoIP = NO;

    /// add left bar
    CGRect leftframe = CGRectMake(0, 0, 18, 15);
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:leftframe];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    leftBtn.tag = 1;
    [leftBtn addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  导航左面按钮点击事件
 */
- (void)leftBarButtonItemPressed:(id)sender {
    [self.navigationController popToViewController:[FriendViewController shareInstance] animated:YES];
}

@end
