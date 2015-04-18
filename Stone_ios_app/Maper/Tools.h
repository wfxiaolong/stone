//
//  tools.h
//  maper
//
//  Created by linxiaolong on 15/1/10.
//  Copyright (c) 2015年 xlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface tools : NSObject

+ (id)toArrayOrNSDictionary:(NSData *)jsonData;

+ (NSString *)getCurrentTime;

@end
