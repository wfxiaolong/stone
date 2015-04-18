//
//  FriendViewController.h
//  maper
//
//  Created by xlong on 15-01-22.
//  Copyright (c) 2014年 xlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FriendViewDelegate <NSObject>

- (void)loginOut;

@end

@interface FriendViewController : UIViewController

+ (instancetype)shareInstance;

@property (nonatomic, weak) id<FriendViewDelegate> delegate;

- (void)updateListView;

- (void)updateFriendList;

@end
