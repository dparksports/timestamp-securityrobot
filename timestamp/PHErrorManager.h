//
//  PHErrorManager
//  Web Socket Server
//
//  Created by Dan Park on 8/11/14.
//  Copyright (c) 2014 Magic Point Inc. All rights reserved.
//


#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

// debug
#import "MJDebugHeader.h"

@interface PHErrorManager : NSObject
// generic
+ (void)showErrorAlert:(NSString*)title message:(NSString*)message;
+ (void)showErrorAlert:(NSError*)error;
+ (NSString*)stringFailureReasonAndDescription:(NSError*)error;
@end
