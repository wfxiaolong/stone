//
//  NoteView.h
//  Stone
//
//  Created by linxiaolong on 15/4/8.
//  Copyright (c) 2015年 xlong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class iCarousel;

@interface NoteView : UIView 

- (void)changeSize:(CGFloat)height;

@property (nonatomic, retain) iCarousel *carousel;

@end
