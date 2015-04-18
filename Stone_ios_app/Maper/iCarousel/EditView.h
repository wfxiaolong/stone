//
//  EditView.h
//  Stone
//
//  Created by linxiaolong on 15/4/8.
//  Copyright (c) 2015年 xlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditDelegate <NSObject>

- (void)completeTime:(NSString *)time Note:(NSString *)note;

@end

@interface EditView : UIView

@property (nonatomic, weak) id<EditDelegate> delegate;

@property (nonatomic, strong) UILabel    *lableTime;
@property (nonatomic, strong) UITextView *textView;

- (void)show;

@end
