//
//  NoteInfo.m
//  Stone
//
//  Created by linxiaolong on 15/4/9.
//  Copyright (c) 2015年 xlong. All rights reserved.
//

#import "NoteInfo.h"
#import "Tools.h"

@implementation NoteInfo

+ (instancetype)shareInstance {
    static dispatch_once_t oncet;
    static id instance;
    dispatch_once(&oncet, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

#pragma -mark transfer to nsdata

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.dataArray forKey:@"dataArray"];
    [aCoder encodeObject:self.timeArray forKey:@"timeArray"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.dataArray = [aDecoder decodeObjectForKey:@"dataArray"];
        self.timeArray = [aDecoder decodeObjectForKey:@"timeArray"];
    }
    return self;
}

- (void)storeData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NoteInfo *tdata = [NoteInfo shareInstance];
    if (tdata != nil) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tdata];
        [userDefaults setObject:data forKey:@"NoteInfo"];
    }
}

- (void)delData {
    self.dataArray = nil;
    [self storeData];
}

- (void)fetchData {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefault objectForKey:@"NoteInfo"];
    if (data != nil) {
        NoteInfo *ndata = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (ndata.dataArray != nil && ndata.timeArray != nil) {
            self.dataArray = ndata.dataArray;
            self.timeArray = ndata.timeArray;
        }
    } else {
        self.dataArray = @[@"新鲜的笔记本.", @"新鲜的笔记本.", @"新鲜的笔记本."];
        self.timeArray = @[[tools getCurrentTime], [tools getCurrentTime], [tools getCurrentTime]];
    }
}

- (void)initWithNData:(NSArray *)narray TData:(NSArray *)tarray {
    if (narray != nil && tarray != nil) {
        self.dataArray = narray;
        self.timeArray = tarray;
        [self storeData];
    }
}

@end
