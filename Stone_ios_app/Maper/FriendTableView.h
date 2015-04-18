//
//  FriendTableView.h
//  Stone
//
//  Created by linxiaolong on 15/3/27.
//  Copyright (c) 2015年 xlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol friendViewDelegate <NSObject>

- (void)changeScollViewFloat:(CGFloat)count;

@end

@interface FriendTableView : UITableView

@property (nonatomic, weak)id<friendViewDelegate> friDelegate;

@property (nonatomic, strong) NSArray *talkArray;
@property (nonatomic, strong) NSMutableArray *friendArray;
@property (nonatomic, strong) NSMutableDictionary *friendDic;

- (void)updateData;

@end
