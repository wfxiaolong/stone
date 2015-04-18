//
//  EditView.m
//  Stone
//
//  Created by linxiaolong on 15/4/8.
//  Copyright (c) 2015年 xlong. All rights reserved.
//

#import "EditView.h"
#import "Tools.h"

#define VIEWWIDTH  [UIScreen mainScreen].bounds.size.width
#define VIEWHEIGHT [UIScreen mainScreen].bounds.size.height

@interface EditView () <UITextViewDelegate>

@property (nonatomic, strong) UIButton *completeBtn;

@property (nonatomic, strong) UIButton *finishBtn;

@end

@implementation EditView

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, VIEWWIDTH, VIEWHEIGHT)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        backBtn.frame = self.frame;
        backBtn.backgroundColor = [UIColor clearColor];
        [backBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        
        self.completeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.completeBtn.frame = CGRectMake(VIEWWIDTH-100, 0, 0, 0);
        [self.completeBtn setTitle:@"         完成" forState:UIControlStateNormal];
        [self.completeBtn addTarget:self action:@selector(textComplete:) forControlEvents:UIControlEventTouchUpInside];
        self.completeBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [self.completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:self.completeBtn];
        
        self.finishBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.finishBtn.frame = CGRectMake(0, 0, 0, 0);
        [self.finishBtn setTitle:@"     返回" forState:UIControlStateNormal];
        self.finishBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.finishBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.finishBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [self.finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:self.finishBtn];
        
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(VIEWWIDTH/2, 150, 1, 1)];
        self.textView.font = [UIFont systemFontOfSize:18];
        self.textView.layer.cornerRadius = 12;
        self.textView.layer.borderWidth = 0.5;
        self.textView.layer.borderColor = [UIColor blackColor].CGColor;
        self.textView.textContainerInset = UIEdgeInsetsMake(30, 8, 10, 8);
        self.textView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.textView.delegate = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
        
        [self addSubview:self.textView];
        
        self.lableTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, VIEWWIDTH-40, 20)];
        self.lableTime.font = [UIFont systemFontOfSize:16];
        self.lableTime.textAlignment = NSTextAlignmentCenter;
        self.lableTime.textColor = [UIColor grayColor];
        [self.textView addSubview:self.lableTime];
        
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    if ([self.textView.text isEqualToString:@"新鲜的笔记📒\n点击编辑..."]) {
        self.textView.textColor = [UIColor grayColor];
    }
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:30 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.textView.frame = CGRectMake(20, 64, VIEWWIDTH-40, VIEWHEIGHT-128);
        self.completeBtn.frame = CGRectMake(VIEWWIDTH-140, 0, 140, 80);
        self.finishBtn.frame = CGRectMake(0, 0, 140, 80);
        
        self.backgroundColor = [UIColor colorWithRed:110.0f/255 green:110.f/255 blue:110.f/255 alpha:0.8];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma -mark textView keyboard button delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.textView.text isEqualToString:@"新鲜的笔记📒\n点击编辑..."]) {
        self.textView.textColor = [UIColor blackColor];
        self.textView.text = @"";
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    [self.textView scrollRectToVisible:CGRectMake(0, 0, 0, 50) animated:YES];
}

- (void)keyboardWasShown:(NSNotification *) notif {
    // get keyboard height
    NSDictionary *info = [notif userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^
     {
         UIEdgeInsets f = self.textView.contentInset;
         f.bottom = keyboardRect.size.height - 64;
         self.textView.contentInset = f;
         
     }completion:^(BOOL finished) {}];
}

- (void)btnClicked:(UIButton *)sender {
    [self textComplete:nil];
    [UIView animateWithDuration:0.3 animations:^{
        self.textView.frame    = CGRectMake(VIEWWIDTH/2, 150, 0, 0);
        self.completeBtn.frame = CGRectMake(VIEWWIDTH-140, 0, 0, 0);
        self.finishBtn.frame   = CGRectMake(0, 0, 0, 0);
        
        self.backgroundColor = [UIColor colorWithRed:110.0f/255 green:110.f/255 blue:110.f/255 alpha:0];
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(completeTime:Note:)]) {
            [self.delegate completeTime:[tools getCurrentTime] Note:self.textView.text];
        }
        [self removeFromSuperview];
    }];
}

- (void)textComplete:(UIButton *)sender {
    UIEdgeInsets f = self.textView.contentInset;
    f.bottom = 8;
    self.textView.contentInset = f;
    [self endEditing:YES];
}

@end
