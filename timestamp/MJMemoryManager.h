//
//  MJMemoryManager.h
//  MJLibrary
//
//  Created by Dan Park on 8/24/14.
//  Copyright (c) 2014 Magic Point. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJMemoryManager : NSObject

+(NSString*) captureMemUsageGetString;
+(NSString*) captureMemUsageGetString:(NSString*) formatstring;
+(float) usedMemoryInMB;
+(NSUInteger) usedMemoryInKB;
@end
