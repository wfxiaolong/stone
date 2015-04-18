//
//  NoteView.m
//  Stone
//
//  Created by linxiaolong on 15/4/8.
//  Copyright (c) 2015年 xlong. All rights reserved.
//

#import "NoteView.h"
#import "iCarousel.h"
#import "coverView.h"
#import "EditView.h"
#import "NoteInfo.h"
#import "Tools.h"

#define VIEWWIDTH  [UIScreen mainScreen].bounds.size.width
#define VSELFHEIGHT 320
#define VIEWHEIGTH  200

@interface NoteView () <iCarouselDataSource, iCarouselDelegate, EditDelegate>

@property (nonatomic, strong) UIImageView *backImg;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *delBtn;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *timeArray;

@end

@implementation NoteView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, -VSELFHEIGHT, VIEWWIDTH, VSELFHEIGHT)];
    if (self) {
        // data
        [self configureData];
        
        self.backImg             = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, VIEWWIDTH, VSELFHEIGHT)];
        NSString *filePath       = [[NSBundle mainBundle] pathForResource:@"carouselBack" ofType:@"png"];
        self.backImg.image       = [UIImage imageWithContentsOfFile:filePath];
        self.backImg.contentMode = UIViewContentModeScaleAspectFill;
        self.backImg.opaque      = YES;
        [self addSubview:self.backImg];
        
        //configure carousel
        self.carousel            = [[iCarousel alloc] initWithFrame:CGRectMake(0, 20, VIEWWIDTH, VIEWHEIGTH)];
        self.carousel.type       = iCarouselTypeCoverFlow;
        self.carousel.delegate   = self;
        self.carousel.dataSource = self;
        [self addSubview:self.carousel];

        self.delBtn              = [UIButton buttonWithType:UIButtonTypeSystem];
        [_delBtn setBackgroundImage:[UIImage imageNamed:@"btn_add"] forState:UIControlStateNormal];
        _delBtn.frame            = CGRectMake(10, 30, 40, 40);
        _delBtn.tag              = 2;
        [_delBtn addTarget:self action:@selector(carouselBtn:) forControlEvents:UIControlEventTouchUpInside];

        _addBtn                  = [UIButton buttonWithType:UIButtonTypeSystem];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"btn_white_delete"] forState:UIControlStateNormal];
        _addBtn.frame            = CGRectMake(VIEWWIDTH-50, 30, 40, 40);
        _addBtn.tag              = 1;
        [_addBtn addTarget:self action:@selector(carouselBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_addBtn becomeFirstResponder];
        [self addSubview:_delBtn];
        [self addSubview:_addBtn];
        
    }
    return self;
}

- (void)dealloc {
    _carousel.delegate = nil;
    _carousel.dataSource = nil;
}

- (void)configureData {
    NoteInfo *note = [NoteInfo shareInstance];
    [note fetchData];
    self.dataArray = note.dataArray.mutableCopy;
    self.timeArray = note.timeArray.mutableCopy;
    
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return self.dataArray.count;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel {
    //limit the number of items views loaded concurrently (for performance reasons)
    //this also affects the appearance of circular-type carousels
    return 9;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    //create new view if no view is available for recycling
    coverView *cView = (coverView *)view;
    if (cView == nil) {
        cView = [[coverView alloc] initWithFrame:CGRectMake(0, 64, VIEWWIDTH/2, VIEWHEIGTH)];
    }
    cView.lable.text = [NSString stringWithFormat:@"%@", self.dataArray[index]];
    [cView.backBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cView;
}

- (NSInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel {
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    //    return YES? 2: 0;
    return 2;
}

- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view {
    //create new view if no view is available for recycling
    coverView *cView = (coverView *)view;
    if (cView == nil) {
        cView = [[coverView alloc] initWithFrame:CGRectMake(0, 64, VIEWWIDTH/2, VIEWHEIGTH)];
    }
    cView.lable.text = [NSString stringWithFormat:@"输入点东西吧..."];
    return cView;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
    return 170;
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    switch (option) {
        case iCarouselOptionWrap:
            return YES;
        default:
            break;
    }
    return value;
}

#pragma -mark get the negative count

- (void)changeSize:(CGFloat)height {
    if (height < -VSELFHEIGHT) {
        CGRect f = self.frame;
        f.origin.y = height;
        f.size.height = -height;
        self.frame = f;
        self.carousel.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, (-height-320)/2);
        
        CGRect cf = self.frame;
        cf.origin.y = 0;
        self.backImg.frame = cf;
    }
}

#pragma -mark btn

- (void)btnClicked:(UIButton *)sender {
    NSInteger index = self.carousel.currentItemIndex;
    EditView *editView = [[EditView alloc] init];
    editView.textView.text = self.dataArray[index];
    editView.lableTime.text = self.timeArray[index];
    editView.delegate = self;
    [editView show];
}

- (void)carouselBtn:(UIButton *)sender {
    if (1 == sender.tag) {
        /// delete
        if (self.carousel.numberOfItems > 1) {
            NSInteger index = self.carousel.currentItemIndex;
            [self.dataArray removeObjectAtIndex:(NSUInteger)index];
            [self.timeArray removeObjectAtIndex:(NSUInteger)index];
            [self.carousel removeItemAtIndex:index animated:YES];
        }
    } else if (2 == sender.tag) {
        /// add
        NSInteger index = MAX(0, self.carousel.currentItemIndex);
        [self.dataArray insertObject:@"新鲜的笔记📒\n点击编辑..." atIndex:(NSUInteger)index];
        [self.timeArray insertObject:[tools getCurrentTime] atIndex:(NSUInteger)index];
        [self.carousel insertItemAtIndex:index animated:YES];
    }
}

#pragma -mark delegate

- (void)completeTime:(NSString *)time Note:(NSString *)note {
    NSInteger index = self.carousel.currentItemIndex;
    [self.dataArray replaceObjectAtIndex:index withObject:note];
    [self.timeArray replaceObjectAtIndex:index withObject:time];
    coverView *coverV = (coverView *)[self.carousel itemViewAtIndex:index];
    coverV.lable.text = note;
    
    // store
    [[NoteInfo shareInstance] initWithNData:self.dataArray TData:self.timeArray];
}

@end
