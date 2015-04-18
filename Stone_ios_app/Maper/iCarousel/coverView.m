//
//  coverView.m
//  tes_view
//
//  Created by linxiaolong on 15/3/26.
//  Copyright (c) 2015年 linxiaolong. All rights reserved.
//

#import "coverView.h"
#import "FXImageView.h"

@interface coverView ()

@end

@implementation coverView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        FXImageView *backImg = [[FXImageView alloc] initWithFrame:frame];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"noteBack" ofType:@"png"];;
        backImg.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
        backImg.contentMode = UIViewContentModeScaleToFill;
        
        backImg.asynchronous = YES;
        backImg.reflectionScale = 0.5f;
        backImg.reflectionAlpha = 0.25f;
        backImg.reflectionGap = 10.0f;
        backImg.shadowOffset = CGSizeMake(0.0f, 2.0f);
        backImg.shadowBlur = 5.0f;
        backImg.cornerRadius = 10.0f;
        
        [self addSubview:backImg];
        
        self.lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, frame.size.width-20, frame.size.height-20)];
        self.lable.textAlignment = NSTextAlignmentCenter;
        self.lable.numberOfLines = 5;
        self.lable.font = [UIFont systemFontOfSize:14];
        self.lable.textColor = [UIColor grayColor];
        [self addSubview:self.lable];
        
        self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 60, frame.size.width, frame.size.height)];
        self.backBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backBtn];
        
    }
    return self;
}

@end
