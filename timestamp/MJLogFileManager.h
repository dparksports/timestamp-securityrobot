//
//  MJLogFileManager.h
//  Encoder Demo
//
//  Created by Dan Park on 8/25/14.
//  Copyright (c) 2014 Magic Point. All rights reserved.
//

// debug
#import "MJDebugHeader.h"
// error
#import "PHErrorManager.h"
// file
#import "PHFileManager.h"
// calendar
#import "PHCalendarCalculate.h"

@interface MJLogFileManager : NSObject

+ (void)logStringToFile:(NSString*)string file:(NSString*)fileName;
+ (void)logErrorToFile:(NSError*)error file:(NSString*)fileName;
@end
