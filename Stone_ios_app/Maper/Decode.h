//
//  decode.h
//  maper
//
//  Created by xlong on 15-01-26.
//  Copyright (c) 2014年 xlong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

#define __BASE64( text )        [CommonFunc base64StringFromText:text]
#define __TEXT( base64 )        [CommonFunc textFromBase64String:base64]

@interface decode : NSObject

//RC4
+ (NSString*) encryptData:(NSString*)dataStr WithRc4Key:(NSString*)key;
+ (NSData*) encryptWithData:(NSData*)data WithRc4Key:(NSString*)key;
//maper code
+ (NSString *)codeString:(NSString *)realStr key:(NSString *)key;
+ (NSString*)base64forData:(NSData*)theData;
@end

//压缩数据
int zlibEncompressWithData(NSData*  unCompressData, NSData** compressData);
int zlibDecompressWithData(NSData* compressData, NSData** unCompressData);

//base64
NSString * AFBase64EncodedStringFromString(NSData *string);