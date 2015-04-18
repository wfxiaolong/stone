//
//  ownInfo.h
//  Stone
//
//  Created by linxiaolong on 15/2/10.
//  Copyright (c) 2015年 xlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface personInfo : NSObject<NSCoding>

/// single instance
+ (id)shareInstance;

- (void)storeData;

- (void)delData;

- (void)fetchData;

/// init self
- (void)InitWithUid:(NSString *)uid portrait:(NSString *)portrait name:(NSString *)name stoken:(NSString *)stoken token:(NSString *)token;

/// evaluate the data
- (void)evaluateData;

/// name
@property (nonatomic, strong) NSString *name;

/// potrait url
@property (nonatomic, strong) NSString *portrait;

/// uid
@property (nonatomic, strong) NSString *uid;

/// stoken for rongCloud
@property (nonatomic, strong) NSString *stoken;

/// token for server
@property (nonatomic, strong) NSString *token;

@end



@interface friendListInfo : NSObject<NSCoding>

/// the single instance
+ (instancetype)shareInstance;

- (void)storeData;

- (void)delData;

- (void)fetchData;

/// init self
- (void)initWithArray: (NSMutableArray *)array listDic: (NSMutableDictionary *)dic;

/// friendListArray : the structure of the friendList
@property (nonatomic, strong) NSMutableArray *friendListArray;

/// userInfoListDic : get the info from the dictionary by the uid
@property (nonatomic, strong) NSMutableDictionary *friendListDic;

@end