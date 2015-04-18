//
//  MainViewController.m
//  maper
//
//  Created by xlong on 15-01-22.
//  Copyright (c) 2014年 xlong. All rights reserved.
//

#import "MainViewController.h"
#import "loginViewController.h"
#import "friendViewController.h"

#import "MBProgressHUD+Add.h"

#import "RCIM.h"
#import "UserInfo.h"
#import "STNetwork.h"

@interface MainViewController () <FriendViewDelegate, RCIMReceiveMessageDelegate>

//user
@property (nonatomic, strong) personInfo *myInfo;

@property (nonatomic, strong) FriendViewController *friendViewC;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // friendView
    self.friendViewC = [FriendViewController shareInstance];
    self.friendViewC.delegate = self;
    UINavigationController *friendNav = [[UINavigationController alloc] initWithRootViewController:self.friendViewC];
    
    [self.view addSubview:friendNav.view];
    [self addChildViewController:friendNav];
    
    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    /// data setting
    self.myInfo = [personInfo shareInstance];
    if ([self.myInfo.stoken length] == 0 || [self.myInfo.token length] == 0) {
        [self needLogining];
        return;
    }
    [self connectToRCServer:self.myInfo.stoken];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)needLogining {
    [[personInfo shareInstance] delData];
    [[friendListInfo shareInstance] delData];
    LoginViewController *loginView = [[LoginViewController alloc]init];
    loginView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:loginView animated:YES completion:^{}];
}

- (void)connectToRCServer:(NSString *)stoken {
    NSLog(@"connect to the rong cloud...");
    [RCIM connectWithToken:stoken completion:^(NSString *userId) {
        NSLog(@"rong cloud loginning succees.");
        [self.friendViewC updateListView];
    } error:^(RCConnectErrorCode status) {
        NSLog(@"rong cloud loginning fail.");
        [[STNetwork alloc] refresh:self.myInfo.uid token:self.myInfo.token handler:^(NSString *domain) {
            if (domain == nil) {
                [RCIM connectWithToken:self.myInfo.stoken completion:^(NSString *userId) {
                    NSLog(@"rong cloud loginning succees.");
                } error:^(RCConnectErrorCode status) {
                    NSLog(@"fail to connect the rong cloud");
                    [self needLogining];
                }];
            }
        }];
    }];
    
#warning -- 这里是个bug 容云的服务器偶尔链接不上，已经反馈，据说下个版本会改好......
    [self.friendViewC updateFriendList];
}

#pragma - mark friendVC Delegate

- (void)loginOut {
    [self needLogining];
}

@end
