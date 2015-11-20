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
