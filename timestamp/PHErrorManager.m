//
//  PHErrorManager
//  Web Socket Server
//
//  Created by Dan Park on 8/11/14.
//  Copyright (c) 2014 Magic Point Inc. All rights reserved.
//

#import "PHErrorManager.h"

@implementation PHErrorManager

+ (void)showErrorAlert:(NSString*)title message:(NSString*)message {
#if TARGET_OS_IPHONE
//    DLOG(@"message:%@", message);
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//    dispatch_queue_t queue = dispatch_get_main_queue();
//    dispatch_async(queue, ^(void) {
//        // in main queue: to show it immediately, not some time after.
//        [alertView show];
//    });
#endif
}

+ (void)showErrorAlert:(NSError*)error {
    NSString *title = [error localizedDescription];
    NSString *string = [error localizedFailureReason];
    DLOG(@"localizedFailureReason:%@", string);
    [self.class showErrorAlert:title message:string];
}

+ (NSString*)stringFailureReasonAndDescription:(NSError*)error {
    NSString *title = [error localizedDescription];
    NSString *string = [error localizedFailureReason];
    DLOG(@"localizedFailureReason:%@", string);
    return [NSString stringWithFormat:@"%@:reason[%@]:code:%ld",
            title, string, (long)[error code]];
}
@end