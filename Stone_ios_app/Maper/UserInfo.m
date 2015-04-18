//
//  ownInfo.m
//  Stone
//
//  Created by linxiaolong on 15/2/10.
//  Copyright (c) 2015年 xlong. All rights reserved.
//

#import "UserInfo.h"

@implementation personInfo

+ (instancetype)shareInstance {
    static dispatch_once_t oncet;
    static personInfo *instance;
    dispatch_once(&oncet, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

- (void)InitWithUid:(NSString *)uid portrait:(NSString *)portrait name:(NSString *)name stoken:(NSString *)stoken token:(NSString *)token {
    self.uid = uid;
    self.portrait = portrait;
    self.name = name;
    self.stoken = stoken;
    self.token = token;
    [self storeData];
}

- (void)evaluateData {
    if ([self.portrait isEqualToString: @""] || self.portrait == nil) {
        self.portrait = @"http://rongcloud-web.qiniudn.com/docs_demo_rongcloud_logo.png";
    }
    if ([self.name isEqualToString: @""]) {
        self.name = @"error";
    }
}

#pragma -mark transfer to nsdata

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.portrait forKey:@"portrait"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.stoken forKey:@"stoken"];
    [aCoder encodeObject:self.token forKey:@"token"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.portrait = [aDecoder decodeObjectForKey:@"portrait"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.stoken = [aDecoder decodeObjectForKey:@"stoken"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
    }
    return self;
}

- (void)storeData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    personInfo *tdata = [personInfo shareInstance];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tdata];
    [userDefaults setObject:data forKey:@"personInfo"];
}

- (void)delData {
    self.uid = nil;
    self.portrait = nil;
    self.name = nil;
    self.stoken = nil;
    self.stoken = nil;
    self.token = nil;
    [self storeData];
}

- (void)fetchData {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefault objectForKey:@"personInfo"];
    if (data != nil) {
        personInfo *udata = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (udata != nil) {
            self.uid = udata.uid;
            self.portrait = udata.portrait;
            self.name = udata.name;
            self.stoken = udata.stoken;
            self.token = udata.token;
        }
    } else {
        self.uid = @"";
        self.portrait = @"";
        self.name = @"";
        self.stoken = @"";
        self.token = @"";
    }
}

@end


@implementation friendListInfo

+ (friendListInfo *)shareInstance {
    static dispatch_once_t oncet;
    static friendListInfo *instance;
    dispatch_once(&oncet, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init{
    if(self=[super init]) {
        self.friendListArray = @[].mutableCopy;
        self.friendListDic = @{}.mutableCopy;
    }
    return self;
}

- (void)initWithArray:(NSArray *)array listDic:(NSDictionary *)dic {
    if (array != nil) {
        self.friendListArray = array.mutableCopy;
    }
    if (dic != nil) {
        self.friendListDic = dic.mutableCopy;
    }
    [self storeData];
}

- (void)storeData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    friendListInfo *tdata = [friendListInfo shareInstance];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tdata];
    [userDefaults setObject:data forKey:@"friendListInfo"];
}

- (void)delData {
    self.friendListArray = nil;
    self.friendListDic = nil;
    [self storeData];
}

- (void)fetchData {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefault objectForKey:@"friendListInfo"];
    if (data == nil) {
        return;
    }
    friendListInfo *udata = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (udata.friendListDic != nil) {
        self.friendListDic = udata.friendListDic;
    }
    if (udata.friendListArray != nil) {
        self.friendListArray = udata.friendListArray;
    }
}

#pragma -mark transfer to nsdata

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.friendListArray forKey:@"friendListArray"];
    [aCoder encodeObject:self.friendListDic forKey:@"friendListDic"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.friendListArray = [aDecoder decodeObjectForKey:@"friendListArray"];
        self.friendListDic = [aDecoder decodeObjectForKey:@"friendListDic"];
    }
    return self;
}

@end