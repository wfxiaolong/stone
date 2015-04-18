//
//  DoMoreView.h
//  maper
//
//  Created by xlong on 15-01-26.
//  Copyright (c) 2014年 xlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DomoreDelegate <NSObject>

- (void)selectAtIndex:(NSInteger)row;

@end

@interface DoMoreView : UIView

@property (nonatomic, weak) id<DomoreDelegate> delegate;

- (void)showSelf;
- (void)hiddenSelf;

@end
