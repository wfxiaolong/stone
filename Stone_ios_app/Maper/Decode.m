//
//  decode.m
//  maper
//
//  Created by xlong on 15-01-26.
//  Copyright (c) 2014年 xlong. All rights reserved.
//

#import "Decode.h"
#include "zlib.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>

//#define MapKey @"6024bc1feaef772b_user/login"

@implementation decode

#pragma mark - rc4 encrypt
+ (NSString*) encryptData:(NSString*)dataStr WithRc4Key:(NSString*)key {
    int S[255] = {0};   //S盒
    unichar result[dataStr.length];   //加密结果
    const unichar * pResult = result;
    for (int i = 0; i < 255; ++i) {
        S[i] = i;
    }
    
    //密钥打乱S盒
    int j = 0;
    for (int i = 0; i < 255; ++i) {
        j = (j + S[i] + [key characterAtIndex:(i % key.length)]) % 256;
        [decode swap:&S[i] withValue: &S[j]];
    }
    
    //加密
    int i = 0;
    j = 0;
    for(int k = 0; k < dataStr.length; ++k) {
        i = (i + 1) % 256;
        j = (j + S[i]) % 256;
        
        [decode swap:&S[i] withValue: &S[j]];
        
        result[k] = [dataStr characterAtIndex:k] ^ S[S[i] + S[j]] % 256;
    }
    return [[NSString alloc]initWithCharacters:pResult length:dataStr.length];
}

+ (NSString*)decryptData:(NSString*)dataStr WithRc4Key:(NSString*)key {
    return [self encryptData:dataStr WithRc4Key:key];
}
+ (void)swap:(int*)pValue1 withValue:(int*)pValue2 {
    int tmp = *pValue1;
    *pValue1 = *pValue2;
    *pValue2 = tmp;
}
#pragma mark - rc4 data
+ (NSData*) encryptWithData:(NSData*)data WithRc4Key:(NSString*)key {
    int *S = (int*)malloc(sizeof(int)*256);
    Byte *result = (Byte*)malloc(sizeof(Byte)*data.length);
    
    const Byte * pResult = result;
    for (int i = 0; i < 256; ++i) {
        S[i] = i;
    }
    
    //密钥打乱S盒
    Byte *pKey = (Byte*)[[key dataUsingEncoding:NSUTF8StringEncoding] bytes];
    NSUInteger keyLength = key.length;
    int j = 0;
    for (int i = 0; i < 256; ++i) {
        j = (j + S[i] + *(pKey + i % keyLength)) % 256;
        [decode swap:&S[i] withValue: &S[j]];
    }
    Byte *pByte = (Byte*)[data bytes];
    //加密
    int i = 0;
    j = 0;
    for(int k = 0; k < data.length; ++k) {
        i = (i + 1) % 256;
        j = (j + S[i]) % 256;
        
        [decode swap:&S[i] withValue: &S[j]];
        
        Byte firstByte = *(pByte + k);
        Byte secondByte = S[(S[i] + S[j]) % 256];
        result[k] = firstByte ^ secondByte;
    }
    
    NSData *resultData = [NSData dataWithBytes:pResult length:data.length];
    free(S);
    free(result);
    return resultData;
}


+ (NSString*)base64forData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    NSInteger i,i2;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        for (i2=0; i2<3; i2++) {
            value <<= 8;
            if (i+i2 < length) {
                value |= (0xFF & input[i+i2]);
            }
        }
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

//maper encode
+ (NSString *)codeString:(NSString *)realStr key:(NSString *)key{
    NSData * data = [realStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData * compressData;
    zlibEncompressWithData(data, &compressData);
    NSData *rc4Str = [self encryptWithData:compressData WithRc4Key:key];
    return [rc4Str base64EncodedStringWithOptions:0];
//    return [self base64forData:rc4Str];
}


@end

#pragma mark - zlibCompress
int zlibEncompressWithData(NSData*  unCompressData, NSData** compressData) {
    int ret;
    z_stream strm;
    
    /* allocate inflate state */
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.avail_in = (uInt)[unCompressData length];
    strm.next_in = (Byte*)[unCompressData bytes];
    ret = deflateInit(&strm, Z_DEFAULT_COMPRESSION);
    if (ret != Z_OK)
        return ret;
    
    // destination buffer size must be at least 0.1% larger than avail_in plus 12 bytes.
    NSMutableData *tCompressData = [NSMutableData dataWithLength:16384];
    
    /* decompress until deflate stream ends or end of file */
    do {
        strm.avail_out = (uInt)([tCompressData length] - strm.total_out);
        strm.next_out = (Byte*)[tCompressData mutableBytes] + strm.total_out;
        
        ret = deflate(&strm, Z_FINISH);
        assert(ret != Z_STREAM_ERROR);  /* state not clobbered */
        switch (ret) {
            case Z_NEED_DICT:
                ret = Z_DATA_ERROR;     /* and fall through */
            case Z_DATA_ERROR:
            case Z_BUF_ERROR:
            case Z_MEM_ERROR:
                (void)deflateEnd(&strm);
                return ret;
        }
    } while (strm.avail_in != 0);
    
    /* clean up and return */
    (void)deflateEnd(&strm);
    *compressData = [NSData dataWithBytes:[tCompressData bytes] length:strm.total_out];
    return ret == Z_STREAM_END ? Z_OK : Z_DATA_ERROR;
}

int zlibDecompressWithData(NSData* compressData, NSData **unCompressData) {
    if ([compressData length] <= 0) {
        return Z_STREAM_ERROR;
    }
    
    uInt full_length = (uInt)[compressData length];
    uInt half_length = (uInt)(full_length * 0.5);
    NSMutableData *tDecompressData = [NSMutableData dataWithLength:full_length + half_length];
    
    int ret;
    z_stream strm;
    
    /* allocate inflate state */
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.avail_in = (uInt)[compressData length];
    strm.next_in = (Byte*)[compressData bytes];
    ret = inflateInit(&strm);
    if (ret != Z_OK)
        return ret;
    
    do {
        if (strm.total_out >= [tDecompressData length]) {
            [tDecompressData increaseLengthBy:half_length];
        }
        strm.avail_out = (uInt)([tDecompressData length] - strm.total_out);
        strm.next_out = [tDecompressData mutableBytes]+ strm.total_out;
        
        ret = inflate(&strm, Z_SYNC_FLUSH);
        assert(ret != Z_STREAM_ERROR);  /* state not clobbered */
        switch (ret) {
            case Z_NEED_DICT:
                ret = Z_DATA_ERROR;     /* and fall through */
            case Z_DATA_ERROR:
            case Z_MEM_ERROR:
                (void)inflateEnd(&strm);
                return ret;
        }
    } while (strm.avail_in != 0);
    /* clean up and return */
    (void)inflateEnd(&strm);
    [tDecompressData setLength:strm.total_out];
    *unCompressData = [[NSData alloc]initWithData:tDecompressData];
    return ret == Z_STREAM_END ? Z_OK : Z_DATA_ERROR;
}

NSString * AFBase64EncodedStringFromString(NSData *data) {
//    NSData *data = [NSData dataWithBytes:[string UTF8String] length:[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}
