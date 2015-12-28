//
//  MD5.h
//  HotelSupplies
//
//  Created by 谭伟 on 13-11-20.
//  Copyright (c) 2013年 谭伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MD5Encode : NSObject

+ (NSString *)md5_32:(NSString *)str;
+ (NSString *)md5_16:(NSString *)str;
@end
