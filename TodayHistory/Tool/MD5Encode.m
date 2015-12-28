//
//  MD5.m
//  HotelSupplies
//
//  Created by 谭伟 on 13-11-20.
//  Copyright (c) 2013年 谭伟. All rights reserved.
//

#import "MD5Encode.h"
#import <CommonCrypto/CommonDigest.h>
#import <Security/Security.h>

@implementation MD5Encode

+ (NSString *)md5_32:(NSString *)str
{
    const char *cStr = [str UTF8String];
    
    unsigned char result[32];
    
    memset(result, 0, sizeof(result));
    
    CC_MD5( cStr, (int)strlen(cStr), result );
    
    return [NSString stringWithFormat:
            @"%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x",
            result[0],result[1],result[2],result[3],
            
            result[4],result[5],result[6],result[7],
            
            result[8],result[9],result[10],result[11],
            
            result[12],result[13],result[14],result[15],
            
            result[16], result[17],result[18], result[19],
            
            result[20], result[21],result[22], result[23],
            
            result[24], result[25],result[26], result[27],
            
            result[28], result[29],result[30], result[31]];
}

//md5 16位加密 （大写）
+(NSString *)md5_16:(NSString *)str
{
    const char *cStr = [str UTF8String];
    
    unsigned char result[16];
    
    CC_MD5( cStr, (int)strlen(cStr), result );
    
    return [NSString stringWithFormat:
            
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            
            result[0], result[1], result[2], result[3],
            
            
            
            result[4], result[5], result[6], result[7],
            
            
            
            result[8], result[9], result[10], result[11],
            
            
            
            result[12], result[13], result[14], result[15]
            
            ];
}
@end
