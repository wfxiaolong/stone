//
//  FriendTableView.m
//  Stone
//
//  Created by linxiaolong on 15/3/27.
//  Copyright (c) 2015年 xlong. All rights reserved.
//

#import "FriendTableView.h"
#import "FriendCell.h"
#import "UserInfo.h"
#import "Tools.h"

#import "RCIM.h"
#import "FriendViewController.h"
#import "RWRCChatViewController.h"

#import "UIImageView+WebCache.h"

#import "NoteView.h"

@interface FriendTableView () <UITableViewDelegate, UITableViewDataSource>

// chatView
@property (nonatomic, strong) RWRCChatViewController *chatViewController;

@property (nonatomic, strong) NoteView *noteView;

@property (nonatomic, assign) BOOL isFolder;

@end

static NSString * friendCellIdentify = @"friendCellIdentifier";

@implementation FriendTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
        self.tableFooterView = [[UIView alloc] init];
        
        self.talkArray = @[].mutableCopy;
        friendListInfo *friendInfo = [friendListInfo shareInstance];
        self.friendArray = friendInfo.friendListArray.mutableCopy;
        if (self.friendArray == nil) {
            self.friendArray = @[].mutableCopy;
        }
        self.friendDic = friendInfo.friendListDic.mutableCopy;
        if (self.friendDic == nil) {
            self.friendDic = @{}.mutableCopy;
        }
        
        [self registerNib:[UINib nibWithNibName:@"FriendCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:friendCellIdentify];
        self.delegate = self;
        self.dataSource = self;
        
        self.noteView = [[NoteView alloc] initWithFrame:self.frame];
        [self addSubview:self.noteView];
        [self sendSubviewToBack:self.noteView];
        
        self.isFolder = NO;
    }
    return self;
}

- (void)updateData {
    NSLog(@"update self message...");
    
    NSArray *typeArray = @[[NSNumber numberWithInt:ConversationType_SYSTEM], [NSNumber numberWithInt:ConversationType_PRIVATE], [NSNumber numberWithInt:ConversationType_DISCUSSION], [NSNumber numberWithInt:ConversationType_GROUP]];
    self.talkArray = [[RCIM sharedRCIM] getConversationList:typeArray];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadData];
    });
}

#pragma -mark tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.talkArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 51;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:friendCellIdentify forIndexPath:indexPath];
    RCConversation *rcconver = self.talkArray[indexPath.row];
    NSString *icon = self.friendDic[rcconver.targetId][@"portrait"];
    cell.icon.layer.cornerRadius = 22;
    [cell.icon sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:@"portrait"]];
    cell.name.text = self.friendDic[rcconver.targetId][@"name"];
    
    if ([rcconver.objectName isEqualToString:RCTextMessageTypeIdentifier]) {
        NSString *tmp = rcconver.jsonDict[@"content"];
        NSString *lastMsg = [tmp substringFromIndex:12];
        NSInteger length= lastMsg.length;
        cell.ntext.text=[lastMsg substringToIndex:length-2];
    }else if([rcconver.objectName isEqualToString:RCImageMessageTypeIdentifier]){
        cell.ntext.text=@"图片";
    }else if ([rcconver.objectName isEqualToString:RCVoiceMessageTypeIdentifier]){
        cell.ntext.text=@"语音";
    }
    
    NSDate *dataStr;
    dataStr = [NSDate dateWithTimeIntervalSince1970:rcconver.sentTime/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate:dataStr];
    cell.ntime.text = currentDateStr;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    RCConversation *rcconver = self.talkArray[row];
    
    RWRCChatViewController *chatViewController = [[RWRCChatViewController alloc] init];
    chatViewController.currentTarget = rcconver.targetId;
    chatViewController.currentTargetName = self.friendDic[rcconver.targetId][@"name"];
    chatViewController.portraitStyle = RCUserAvatarCycle;
    chatViewController.conversationType = ConversationType_PRIVATE;
    
    chatViewController.navigationController.navigationItem.title = self.friendDic[rcconver.targetId][@"name"];

    [[[FriendViewController shareInstance] navigationController] pushViewController:chatViewController animated:YES];
}

#pragma -mark scrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsety = scrollView.contentOffset.y;
    [self.noteView changeSize:offsety];
    
    if (-64 > offsety && offsety > -164) {
        if (self.friDelegate && [self.friDelegate respondsToSelector:@selector(changeScollViewFloat:)]) {
            [self.friDelegate changeScollViewFloat:(164 + offsety)];
        }
    }
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    CGFloat offsety = scrollView.contentOffset.y;
    
    if (-offsety > 120 && !self.isFolder) {
        self.isFolder = YES;
        [UIView animateWithDuration:0.4 animations:^{
            self.contentInset = UIEdgeInsetsMake(320, 0, 0, 0);
        }];
        
        if (self.friDelegate && [self.friDelegate respondsToSelector:@selector(changeScollViewFloat:)]) {
            [self.friDelegate changeScollViewFloat:0];
        }
        return;
    }
    if (-offsety < 280 && self.isFolder) {
        self.isFolder = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        }];
        
        if (self.friDelegate && [self.friDelegate respondsToSelector:@selector(changeScollViewFloat:)]) {
            [self.friDelegate changeScollViewFloat:100];
        }
    }
}

@end
