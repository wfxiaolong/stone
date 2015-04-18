//
//  FriendCell.h
//  Stone
//
//  Created by linxiaolong on 15/1/21.
//  Copyright (c) 2015年 xlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *ntext;
@property (weak, nonatomic) IBOutlet UILabel *ntime;

@end
