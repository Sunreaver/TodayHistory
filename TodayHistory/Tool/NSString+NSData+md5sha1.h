//
//  NSString+NSData+md5sha1
//  HotelSupplies
//
//  Created by 谭伟 on 13-11-20.
//  Copyright (c) 2013年 谭伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5Encode)

/**
 *  md5 双倍（32位）加密
 *
 *  @return 输出32位 16进制 小写md5值
 */
- (NSString *)md5_32;

/**
 *  md5 16位加密
 *
 *  @return 输出16位 16进制 小写md5值
 */
- (NSString *)md5_16;
@end

@interface NSString (SHA1Encode)

/**
 *  sha1 加密
 *
 *  @return 输出40位 16进制 小写sha1值
 */
- (NSString*)sha1;

@end

@interface NSData (MD5Encode)

/**
 *  md5 双倍（32位）加密
 *
 *  @return 输出32位 16进制 小写md5值
 */
- (NSString *)md5_32;

/**
 *  md5 16位加密
 *
 *  @return 输出16位 16进制 小写md5值
 */
- (NSString *)md5_16;
@end

@interface NSData (SHA1Encode)

/**
 *  sha1 加密
 *
 *  @return 输出40位 16进制 小写sha1值
 */
- (NSString*)sha1;

@end
