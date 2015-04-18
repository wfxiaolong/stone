//
//  FriendViewController.m
//  maper
//
//  Created by xlong on 15-01-22.
//  Copyright (c) 2014年 xlong. All rights reserved.
//

#import "FriendViewController.h"
#import "FriendTableView.h"
#import "UserInfo.h"

#import "STNetwork.h"
#import "MBProgressHUD+Add.h"
#import "UINavigationBar+Awesome.h"

#import "RCIM.h"
#import "ContactController.h"

#import "DoMoreView.h"

@interface FriendViewController () <UITableViewDelegate, friendViewDelegate, DomoreDelegate, RCIMUserInfoFetcherDelegagte, RCIMReceiveMessageDelegate>

/// userInfo, friendInfo : store the users message
@property (nonatomic, strong) personInfo *myInfo;
@property (nonatomic, strong) friendListInfo *friendInfo;

@property (nonatomic, strong) NSURLConnection *friendListConnection;

// tableView
@property (nonatomic, strong) FriendTableView *tableView;

/// navigationBar
@property (nonatomic, strong) UIBarButtonItem *leftBtn;
@property (nonatomic, strong) UIBarButtonItem *rightBtn;

@end

@implementation FriendViewController

+ (instancetype)shareInstance {
    static dispatch_once_t oncet;
    static id instance;
    dispatch_once(&oncet, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //view setting
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    customLab.textAlignment = NSTextAlignmentCenter;
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"Stone"];
    customLab.font = [UIFont systemFontOfSize: 18.0f];
    self.navigationItem.titleView = customLab;
    self.navigationItem.titleView.tintColor = [UIColor whiteColor];
    
    //buttonItem
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.tag = 1;
    button.frame = CGRectMake(0, 0, 17, 17);
    [button setBackgroundImage:[UIImage imageNamed:@"btn_more"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.leftBtn = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = self.leftBtn;
    
    //buttonItem
    UIButton *rbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    rbutton.tag = 2;
    [rbutton setTitle:@"联系人" forState:UIControlStateNormal];
    [rbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rbutton.frame = CGRectMake(0, 0, 50, 30);
    [rbutton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn = [[UIBarButtonItem alloc]initWithCustomView:rbutton];
    self.navigationItem.rightBarButtonItem = self.rightBtn;
    
    [self getInfomation];
    
    //tableview setting
    self.tableView = [[FriendTableView alloc] initWithFrame:self.view.bounds];
    self.tableView.friDelegate = self;
    [self.view addSubview:self.tableView];
    
    /// RCIM Setting
    [RCIM setUserInfoFetcherWithDelegate:self isCacheUserInfo:YES];
    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor colorWithRed:42.0f/255 green:41.0f/255 blue:48.0f/255 alpha:1]];
    [self.tableView updateData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor colorWithRed:42.0f/255 green:41.0f/255 blue:48.0f/255 alpha:1]];
    [self.navigationController.navigationBar lt_setTranslationY:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/// set the imfo from the userdefault

- (void) getInfomation {
    self.myInfo = [personInfo shareInstance];
    self.friendInfo = [friendListInfo shareInstance];
}

#pragma -mark btnClicked

- (void)btnClicked:(id)sender {
    UIButton *button = (UIButton*)sender;
    if (1 == button.tag) {
        DoMoreView *doView = [[DoMoreView alloc] initWithFrame:self.view.frame];
        doView.delegate = self;
        [doView showSelf];
        
    }else if (2 == button.tag) {
        ContactController *friendListView = [[ContactController alloc]init];
        friendListView.dataArray = self.friendInfo.friendListArray;
        friendListView.dataDic = self.friendInfo.friendListDic;
        [[self navigationController] pushViewController:friendListView animated:YES];
        
    }
}

#pragma -mark tableView delegate

- (void)changeScollViewFloat:(CGFloat)count {
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor colorWithRed:42.0f/255 green:41.0f/255 blue:48.0f/255 alpha:count/100]];
    [self.navigationController.navigationBar lt_setTranslationY:-(1-count/100)*64];
}

#pragma -mark netWork

- (void)updateFriendList {
    MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress];
    [progress show:YES];
    [[STNetwork alloc] getFriendListUid:self.myInfo.uid toekn:self.myInfo.token handler:^(NSString *domain, NSArray *array) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [progress hide:YES];
            if (domain != nil) {
                [MBProgressHUD showSuccess:domain toView:self.view];
            } else {
                self.friendInfo.friendListArray = @[].mutableCopy;
                self.friendInfo.friendListDic = @{}.mutableCopy;
                for (NSArray *key in array) {
                    [self.friendInfo.friendListArray addObject:key];
                    NSString *uidStr = [NSString stringWithFormat:@"%@", [key valueForKey:@"fid"]];
                    [self.friendInfo.friendListDic setObject:key forKey:uidStr];
                }
                
                [[friendListInfo shareInstance] initWithArray:self.friendInfo.friendListArray listDic:self.friendInfo.friendListDic];
                self.tableView.friendDic = self.friendInfo.friendListDic.mutableCopy;
                self.tableView.friendArray = self.friendInfo.friendListArray.mutableCopy;
                [self updateListView];
            }
        });
    }];
}

- (void)updateListView {
    [self.tableView updateData];
}

#pragma -mark domore delegate

- (void) selectAtIndex:(NSInteger)row {
    if (row == 0) {
        [MBProgressHUD showSuccess:@"还没做呢..." toView:[UIApplication sharedApplication].keyWindow];
    } else if (row == 1) {
        [MBProgressHUD showSuccess:@"还没做呢..." toView:[UIApplication sharedApplication].keyWindow];
    } else if (row == 2) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginOut)]) {
            [self.delegate loginOut];
        }
    } else if (row == 3) {
        [MBProgressHUD showSuccess:@"小石头..." toView:[UIApplication sharedApplication].keyWindow];
    }
}

#pragma -mark RCIM delegate



#pragma -mark RCIM delegate

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo*))completion {
    NSDictionary *dic = [self.friendInfo.friendListDic valueForKey:userId];
    RCUserInfo *info = [[RCUserInfo alloc] init];
    info.userId = userId;
    info.name = [dic valueForKey:@"name"];
    info.portraitUri = [dic valueForKey:@"portrait"];
    completion(info);
}

- (void)didReceivedMessage:(RCMessage *)message left:(int)left {
    [self.tableView updateData];
}

@end
