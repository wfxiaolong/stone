//
//  DoMoreView.m
//  maper
//
//  Created by xlong on 15-01-26.
//  Copyright (c) 2014年 xlong. All rights reserved.
//

#import "DoMoreView.h"

#define VIEW_TAG 10001
#define UNLog(xx, ...) NSLog(xx, ##__VA_ARGS__)

@interface DoMoreView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

static NSString *TableIdentifier = @"TableIdentifier";

@implementation DoMoreView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:110.0f/255 green:110.f/255 blue:110.f/255 alpha:0];
                
        /// back view
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        backBtn.frame = [UIScreen mainScreen].bounds;
        backBtn.backgroundColor = [UIColor clearColor];
        [backBtn addTarget:self action:@selector(hiddenSelf) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        
        //tableview
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -270, self.frame.size.width, 300) style:UITableViewStylePlain];
        self.tableView.delegate   = self;
        self.tableView.dataSource = self;
        //viewcell
        self.tableView.backgroundColor = [UIColor colorWithRed:26.0f/255 green:26.f/255 blue:26.f/255 alpha:0.9];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:TableIdentifier];
        self.tableView.rowHeight       = 50;
        self.tableView.scrollEnabled   = NO;
        self.tableView.separatorStyle  = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableView.contentInset    = UIEdgeInsetsMake(40, 0, 0, 0);
        
        // headView
        UIView *headView   = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 20)];
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        closeBtn.frame     = CGRectMake(self.frame.size.width - 40, 5, 24, 24);
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"btn_gray_close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(hiddenSelf) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:closeBtn];
        self.tableView.tableHeaderView = headView;
        
        self.tableView.separatorColor = [UIColor whiteColor];
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 20);
        [self addSubview:self.tableView];

    }
    return self;
}

- (void)showSelf {
    self.tag = VIEW_TAG;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.4 animations:^{
        self.tableView.transform = CGAffineTransformMakeTranslation(0, 270);
        self.backgroundColor = [UIColor colorWithRed:110.0f/255 green:110.f/255 blue:110.f/255 alpha:0.8];
    } completion:^(BOOL finished) {
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.dataArray = @[@"笔记开关" ,@"修改密码", @"退出登录", @"关于"].mutableCopy;
        NSMutableArray *indexArray = @[].mutableCopy;
        for (int a=0; a<self.dataArray.count; a++) {
            NSIndexPath *index = [NSIndexPath indexPathForItem:a inSection:0];
            [indexArray addObject:index];
        }
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    });
}

- (void)hiddenSelf {
    [self.tableView beginUpdates];
    for (int a=0; a<self.dataArray.count; a++) {
        [self.dataArray removeLastObject];
        NSIndexPath *index = [NSIndexPath indexPathForItem:a inSection:0];
        NSArray *indexArray = [NSArray arrayWithObject:index];
        [self.tableView deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationTop];
    }
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.8 animations:^{
        self.tableView.transform = CGAffineTransformMakeTranslation(0, -270);
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma -mark tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell    = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableIdentifier];
    cell.selectionStyle      = UITableViewCellSelectionStyleNone;
    cell.backgroundColor     = [UIColor clearColor];
    cell.textLabel.text      = self.dataArray[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

/// set delegate what you want

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectAtIndex:)]) {
        [self.delegate selectAtIndex:row];
    }
    [self hiddenSelf];
}

@end