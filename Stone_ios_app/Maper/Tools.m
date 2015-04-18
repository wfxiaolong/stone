//
//  tools.m
//  maper
//
//  Created by linxiaolong on 15/1/10.
//  Copyright (c) 2015年 xlong. All rights reserved.
//

#import "Tools.h"

@implementation tools

+ (id)toArrayOrNSDictionary:(NSData *)jsonData {
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    if (jsonObject != nil && error == nil) {
        return jsonObject;
    } else {
        return nil;
    }
    return  nil;
}

+ (NSString *)getCurrentTime {
    NSDate *senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *timeNow = [dateformatter stringFromDate:senddate];
    return timeNow;
}

@end
