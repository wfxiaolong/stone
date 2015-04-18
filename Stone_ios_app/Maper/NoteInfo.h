//
//  NoteInfo.h
//  Stone
//
//  Created by linxiaolong on 15/4/9.
//  Copyright (c) 2015年 xlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteInfo : NSObject <NSCoding>

/// single instance
+ (id)shareInstance;

- (void)storeData;

- (void)delData;

- (void)fetchData;

- (void)initWithNData:(NSArray *)narray TData:(NSArray *)tarray;

/// data
/// the timeArray and the dataArray is the same

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *timeArray;

@end
