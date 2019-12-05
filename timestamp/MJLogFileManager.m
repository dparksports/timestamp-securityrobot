//
//  MJLogFileManager.m
//  Encoder Demo
//
//  Created by Dan Park on 8/25/14.
//  Copyright (c) 2014 Magic Point. All rights reserved.
//

#import "MJLogFileManager.h"

@implementation MJLogFileManager

+ (BOOL)createFileWithData:(NSData*)data path:(NSString*)filePath  {
//    DLOG(@"[data length]:%@", @([data length]));
    NSError *error = nil;
    NSDataWritingOptions options = NSDataWritingAtomic;
    BOOL status = [data writeToFile:filePath options:options error:&error];
    if (error || ! status ) {
        DLOG(@"error:%@", [error localizedDescription]);
    }
    return status;
}

+ (void)appendStringToFile:(NSData*)data path:(NSString*)filePath {
//    DLOG(@"[data length]:%@", @([data length]));
    if ([data length] > 0) {
        NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
        [fileHandler seekToEndOfFile];
        [fileHandler writeData:data];
        [fileHandler closeFile];
    }
}

+ (void)logStringToFile:(NSString*)string file:(NSString*)fileName {
    NSLog(@"log: %@", string);
    if ([string length] > 0) {
        NSString *filePath = [PHFileManager documentDirectory];
        filePath = [filePath stringByAppendingPathComponent:fileName];
        
        NSString *timestamp = [PHCalendarCalculate timestampInShortFormat];
        string = [NSString stringWithFormat:@"%@: %@\n", timestamp, string];
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        if ([PHFileManager fileExistsAtPath:filePath]) {
            [self appendStringToFile:data path:filePath];
        } else {
            [self createFileWithData:data path:filePath];
        }
    }
}

+ (void)logErrorToFile:(NSError*)error file:(NSString*)fileName {
    NSString *string = [NSString stringWithFormat:@"%@, %@",
                        [error localizedDescription], [error localizedDescription]];
    [self logStringToFile:string file:fileName];
}


@end
