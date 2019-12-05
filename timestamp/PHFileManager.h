//
//  PHFileManager
//  Web Socket Server
//
//  Created by Dan Park on 8/13/14.
//  Copyright (c) 2014 Magic Point Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

// debug
#import "MJDebugHeader.h"
// error
#import "PHErrorManager.h"

@interface PHFileManager : NSObject

+ (NSURL*)directoryBySearchPath:(NSSearchPathDirectory) searchPath;
+ (NSURL *)applicationDirectoryURL;
+ (NSURL *)documentDirectoryURL;
+ (NSString *)documentDirectoryString;
+ (NSString *)applicationDirectoryString;

// archive / unarchive from NSCoding
+ (BOOL)archiveDataToProfilesPath:(id)rootObject secureArchive:(BOOL)secureArchive withFileName:(NSString*)fileName;
+ (id)unarchiveDataFromProfilesPath:(BOOL)secureArchive withFileName:(NSString*)fileName;

+ (BOOL)fileExistsAtPath:(NSString*)path;
+ (NSString*)documentDirectory;

@end
