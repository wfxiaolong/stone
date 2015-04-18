//
//  STNetwork.m
//  Stone
//
//  Created by linxiaolong on 15/3/28.
//  Copyright (c) 2015年 xlong. All rights reserved.
//

#import "STNetwork.h"
#import "Config.h"
#import "UserInfo.h"
#import "RCIM.h"

@implementation STNetwork

- (void)loginUid:(NSString *)uid password:(NSString *)psw token:(NSString *)token handler:(NetCompleteBlock)handler {
    UNLog(@"login by psw or token...");
    if ([self isNullDepand:uid]) {
        handler(@"参数错误", nil);
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@user/login?uid=%@&psw=%@&token=%@", APPSERVER, uid, psw, token];
    NSURLRequest *quest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [NSURLConnection sendAsynchronousRequest:quest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError != nil) {
            handler(@"网络出错了,请检查网络环境.", nil);
            return;
        }
        NSString *outString = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
        UNLog(@"outString:%@",outString);
        NSError *error=nil;
        NSDictionary *JsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSInteger c = [JsonObject[@"c"] integerValue];
        
        //验证存储参数，包括sid userid
        if (c == 0 && JsonObject[@"stoken"] != nil) {
            [RCIM connectWithToken:JsonObject[@"stoken"] completion:^(NSString *userId) {
                if ([userId isEqualToString: JsonObject[@"uid"]]) {
                    handler(nil, nil);
                    personInfo *myInfo = [personInfo shareInstance];
                    [myInfo InitWithUid:JsonObject[@"uid"] portrait:JsonObject[@"portrait"] name:JsonObject[@"name"] stoken:JsonObject[@"stoken"] token:JsonObject[@"token"]];
                } else {
                    handler(@"融云验证失败了.", nil);
                }
            } error:^(RCConnectErrorCode status) {
                handler(@"融云登录失败了.", nil);
            }];
        } else if (c == 1) {
            handler(@"请输入有效用户名，密码.", nil);
        } else if (c == 2){
            handler(@"密码错误.", nil);
        } else if (c == 3){
            handler(@"用户名不存在.", nil);
        } else {
            handler(@"出错了.请联系客服:15913519968.", nil);
        }
    }];
}

- (void)registUid:(NSString *)uid password:(NSString *)psw handler:(NetCompleteHandler)handler {
    UNLog(@"regist.");
    if ([self isNullDepand:uid] || [self isNullDepand:psw]) {
        handler(@"参数错误");
    }
    NSString *getUrl = [NSString stringWithFormat:@"%@user/regist?uid=%@&psw=%@", APPSERVER, uid, psw];
    NSURLRequest *registRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:getUrl]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [NSURLConnection sendAsynchronousRequest:registRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError != nil) {
            handler(@"网络出错了，请检查网络环境.");
            return;
        }
        NSString *outString = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
        UNLog(@"outString:%@",outString);
        NSError *error=nil;
        NSDictionary *JsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSInteger c = [JsonObject[@"c"] integerValue];
        if (c == 0 && JsonObject[@"token"] != nil) {
            [RCIM connectWithToken:JsonObject[@"token"] completion:^(NSString *userId) {
                if ([userId isEqualToString:JsonObject[@"uid"]]) {
                    handler(nil);
                    personInfo *myInfo = [personInfo shareInstance];
                    [myInfo InitWithUid:JsonObject[@"uid"] portrait:JsonObject[@"portrait"] name:JsonObject[@"name"] stoken:JsonObject[@"stoken"] token:JsonObject[@"token"]];
                } else {
                    handler(@"融云验证失败了.");
                }
            } error:^(RCConnectErrorCode status) {
                handler(@"融云登录失败了.");
            }];
        } else if (c == 2){
            handler(@"用户已经存在了.");
        } else {
            handler(@"注册失败.请联系客服:15913159968.");
        }
    }];
}

- (void)getFriendListUid:(NSString *)uid toekn:(NSString *)toekn handler:(NetCompleteListBlock)handler {
    UNLog(@"get friend list.");
    if ([self isNullDepand:uid] || [self isNullDepand:toekn]) {
        handler(@"参数错误.❌", nil);
        return;
    }
    NSString *getUrl = [NSString stringWithFormat:@"%@friend/getlist?uid=%@&token=%@", APPSERVER, uid, toekn];
    NSURLRequest *listRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:getUrl]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [NSURLConnection sendAsynchronousRequest:listRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError != nil) {
            NSLog(@"%@", connectionError);
            handler(@"网络出错了，请检查网络环境.", nil);
            return;
        }
        NSString *outString = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
        UNLog(@"outString:%@",outString);
        NSError *error=nil;
        NSDictionary *JsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSNumber * c = JsonObject[@"c"];
        if (!([c intValue] == 0)) {
            handler(@"请求好友列表失败", nil);
            return;
        }else{
            handler(nil, JsonObject[@"d"]);
        }
    }];
}

- (void)refresh:(NSString *)uid token:(NSString *)token handler:(NetCompleteHandler)handler {
    UNLog(@"refresh.");
    if ([self isNullDepand:uid] || [self isNullDepand:token]) {
        handler(@"参数出错");
        return;
    }
    NSString *getUrl = [NSString stringWithFormat:@"%@user/refresh?uid=%@&token=%@", APPSERVER, uid, token];
    NSURLRequest *listRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:getUrl]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [NSURLConnection sendAsynchronousRequest:listRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError != nil) {
            NSLog(@"%@", connectionError);
            handler(@"网络出错了，请检查网络环境. ");
            return;
        }
        NSString *outString = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
        UNLog(@"outString:%@",outString);
        NSError *error=nil;
        NSDictionary *JsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSNumber * c = JsonObject[@"c"];
        if (!([c intValue] == 0)) {
            handler(@"刷新TOKEN失败了.");
            return;
        }else{
            handler(nil);
            personInfo *info = [personInfo shareInstance];
            info.stoken = JsonObject[@"stoken"];
            [info storeData];
        }
    }];
}

- (BOOL)isNullDepand:(NSString *)str {
    if (str == nil || [str isEqualToString:@""]) {
        return YES;
    }
    return NO;
}


@end
