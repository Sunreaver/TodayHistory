//
//  UserDef.h
//  Platform
//
//  Created by Wei Tan on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef Platform_UserDef_h
#define Platform_UserDef_h

#define DelayExamples(T) (T)

#define BadgeNumberDate @"BadgeNumberDate.peter"

#define YEE_COLOR(argb) [UIColor colorWithRed:((argb>>16)&0xff)/255.0 green:((argb>>8)&0xff)/255.0 blue:(argb&0xff)/255.0 alpha:((argb>>24)&0xff)/255.0]

#define Google_Color0 ([UIColor colorWithRed:66.0/255.0 green:133.0/255.0 blue:244.0/255.0 alpha:1.0f])
#define Google_Color1 ([UIColor colorWithRed:234.0/255.0 green:67.0/255.0 blue:53.0/255.0 alpha:1.0])
#define Google_Color2 ([UIColor colorWithRed:251.0/255.0 green:188.0/255.0 blue:5.0/255.0 alpha:1.0f])
#define Google_Color3 ([UIColor colorWithRed:52.0/255.0 green:168.0/255.0 blue:83.0/255.0 alpha:1.0f])

//获取沙盒文件
#define File_Path(filePath) ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSAllDomainsMask, YES) objectAtIndex:0] stringByAppendingPathComponent:filePath])
#define AppGroup_Path(filePath) ([[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.yeeuu.SwissArmyKnife"] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@", filePath]])
#define UserDefaults_SuiteName @"group.com.yeeuu.SwissArmyKnife"

@interface UserDef : NSObject

+(id)getUserDefValue:(NSString*)key;
+(void)setUserDefValue:(id)value keyName:(NSString*)key;
+(void)removeObjectForKey:(NSString*)key;
+(void)synchronize;
@end

#endif
