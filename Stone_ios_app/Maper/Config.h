//
//  config.h
//  Stone
//
//  Created by linxiaolong on 15/1/17.
//  Copyright (c) 2015年 xlong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APPSERVER @"http://172.16.5.232:1234/"

#define DEBUG 1

#if DEBUG

#define UNLog(xx, ...) NSLog(xx, ##__VA_ARGS__)

#else

#define UNLog(xx, ...) NSLog(@"")

#endif