//
//  THBook.h
//  TodayHistory
//
//  Created by 谭伟 on 15/12/28.
//  Copyright © 2015年 谭伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THReadBook.h"

/**
 *  外部使用THBook
 */
typedef THRead THBook;

@interface THReadProgress : NSObject<NSCoding>

@property(nonatomic, retain) NSNumber *page;
@property(nonatomic, retain) NSNumber *day;

+(instancetype)initWithCurPage:(NSUInteger)page CurDay:(NSUInteger)day;

@end
