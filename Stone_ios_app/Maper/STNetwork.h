//
//  STNetwork.h
//  Stone
//
//  Created by linxiaolong on 15/3/28.
//  Copyright (c) 2015年 xlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STNetwork : NSObject

typedef void (^NetCompleteBlock)(NSString *domain, NSDictionary *dic);

typedef void (^NetCompleteHandler)(NSString *domain);

typedef void (^NetCompleteListBlock)(NSString *domain, NSArray *array);

/// interface

- (void)loginUid:(NSString *)uid password:(NSString *)psw token:(NSString *)token handler:(NetCompleteBlock)handler;

- (void)registUid:(NSString *)uid password:(NSString *)psw handler:(NetCompleteHandler)handler;

// get friend List
- (void)getFriendListUid:(NSString *)uid toekn:(NSString *)toekn handler:(NetCompleteListBlock)handler;

// refresh round cloud message
- (void)refresh:(NSString *)uid token:(NSString *)token handler:(NetCompleteHandler)handler;

@end
