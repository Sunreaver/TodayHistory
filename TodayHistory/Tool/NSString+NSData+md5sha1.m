//
//  NSString+NSData+md5sha1.m
//  HotelSupplies
//
//  Created by 谭伟 on 13-11-20.
//  Copyright (c) 2013年 谭伟. All rights reserved.
//

#import "NSString+NSData+md5sha1.h"
#import <CommonCrypto/CommonDigest.h>
#import <Security/Security.h>

@implementation NSString (MD5Encode)

- (NSString *)md5_32
{
    const char *cStr = [self UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH * 2];
    
    memset(result, 0, sizeof(result));
    
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH * 2; i++)
        [output appendFormat:@"%x", result[i]];
    
    return output;
}

-(NSString *)md5_16
{
    const char *cStr = [self UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    memset(result, 0, sizeof(result));
    
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", result[i]];
    
    return output;
}
@end

@implementation NSString (SHA1Encode)

- (NSString*) sha1
{
    const char *cstr = [self UTF8String];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    memset(digest, 0, sizeof(digest));
    
    CC_SHA1(cstr, (CC_LONG)strlen(cstr), digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

@end
@implementation NSData (MD5Encode)

- (NSString *)md5_32
{
    unsigned char result[CC_MD5_DIGEST_LENGTH * 2];
    
    memset(result, 0, sizeof(result));
    
    CC_MD5( self.bytes, (CC_LONG)self.length, result );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH * 2; i++)
        [output appendFormat:@"%x", result[i]];
    
    return output;
}

-(NSString *)md5_16
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    memset(result, 0, sizeof(result));
    
    CC_MD5( self.bytes, (CC_LONG)self.length, result );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", result[i]];
    
    return output;
}
@end

@implementation NSData (SHA1Encode)

- (NSString*) sha1
{
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    memset(digest, 0, sizeof(digest));
    
    CC_SHA1(self.bytes, (CC_LONG)self.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

@end
