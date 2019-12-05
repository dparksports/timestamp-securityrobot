//
//  PHFileManager
//  Web Socket Server
//
//  Created by Dan Park on 8/13/14.
//  Copyright (c) 2014 Magic Point Inc. All rights reserved.
//


#import "PHFileManager.h"

@implementation PHFileManager

+ (NSArray *)uuidFiles {
    NSError *error = nil;
    NSString *profilesPath = [self.class contentDirectory];
    NSArray *directoryFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:profilesPath error:&error];
    if (error) {
        [PHErrorManager showErrorAlert:error];
    }
    return directoryFiles;
}

+ (BOOL)createDocumentPath:(NSString*)newPath {
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDirectory;
    BOOL existsFile = [manager fileExistsAtPath:newPath isDirectory:&isDirectory];
    if (!isDirectory || !existsFile) {
        NSError *error = nil;
        BOOL status = [manager createDirectoryAtPath:newPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error || status == NO) {
            [PHErrorManager showErrorAlert:error];
        }
        return status;
    }
    return NO;
}

+ (NSString*)contentDirectory {
    NSString *documentPath = [self.class documentDirectory];
    documentPath = [documentPath stringByAppendingPathComponent:@"Content"];
    [self.class createDocumentPath:documentPath];
    return documentPath;
}

+ (BOOL)fileExistsAtPath:(NSString*)path {
    BOOL isDirectory;
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL existsFile = [manager fileExistsAtPath:path isDirectory:&isDirectory];
    return existsFile;
}

+ (NSData*)archiveRootObject:(id)rootObject secureArchive:(BOOL)secureArchive{
#define DefaultIncomeModelAllocation 11429*2
    NSUInteger capacity = DefaultIncomeModelAllocation;
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:capacity];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver setRequiresSecureCoding:secureArchive];
    [archiver encodeObject:rootObject forKey:@"RootKeyMAJI"];
    [archiver finishEncoding];
    return data;
}

+ (id)unarchiveRootObject:(NSString*)filePath securedArchive:(BOOL)securedArchive{
    NSError *error = nil;
    NSDataReadingOptions options = NSDataReadingUncached;
    NSData *data = [NSData dataWithContentsOfFile:filePath options:options error:&error];
    if (data) {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        [unarchiver setRequiresSecureCoding:securedArchive];
        id object = nil;
        @try {
            Class class = [NSDictionary class];
            object = [unarchiver decodeObjectOfClass:class forKey:@"RootKeyMAJI"];
        }
        @catch (NSException *exception) {
            NSString *string = [NSString stringWithFormat:@"%@: exception:[%@]", NSStringFromSelector(_cmd), exception];
            DLOG(@"%@", string);
            [PHErrorManager showErrorAlert:nil message:string];
        }
        @finally {
            // no op
        }
        return object;
    }
    return nil;
}

+ (BOOL)writeDataToFilePath:(NSData*)data filePath:(NSString*)filePath{
    NSError *error = nil;
    NSDataWritingOptions options = NSDataWritingAtomic;
    BOOL status = [data writeToFile:filePath options:options error:&error];
    if (error || status == NO) {
        [PHErrorManager showErrorAlert:error];
    }
    return status;
}

#if TARGET_OS_IPHONE
+ (BOOL)appendDataToFilePath:(NSData*)data filePath:(NSString*)filePath{
    if (floor(NSFoundationVersionNumber) >= NSFoundationVersionNumber_iOS_6_0) {
        // iOS 6 and above
        
        NSError *error = nil;
        NSDataWritingOptions options = NSDataWritingWithoutOverwriting;
        BOOL status = [data writeToFile:filePath options:options error:&error];
        if (error || status == NO) {
            [PHErrorManager showErrorAlert:error];
        }
        return status;
    }
    else {
        // below iOS 6
        BOOL status = NO;
        return status;
    }

}
#endif

+ (BOOL)archiveDataToProfilesPath:(id)rootObject secureArchive:(BOOL)secureArchive withFileName:(NSString*)fileName{
    NSString *path = [self.class contentDirectory];
    path = [path stringByAppendingPathComponent:fileName];
    DLOG(@"path:%@", path);
    NSData *data = [self.class archiveRootObject:rootObject secureArchive:secureArchive];
    BOOL status = [self.class writeDataToFilePath:data filePath:path];
    return status;
}

+ (id)unarchiveDataFromProfilesPath:(BOOL)secureArchive withFileName:(NSString*)fileName{
    NSString *path = [self.class contentDirectory];
    path = [path stringByAppendingPathComponent:fileName];
    DLOG(@"path:%@", path);
    id object = [self.class unarchiveRootObject:path securedArchive:secureArchive];
    return object;
}

+ (NSString*)documentDirectory {
    BOOL expandTilde = YES;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, expandTilde);
    NSString *path = ([paths count] > 0) ? [paths firstObject] : nil;
    return path;
}

+ (NSURL*)directoryBySearchPath:(NSSearchPathDirectory) searchPath {
    NSSearchPathDomainMask mask = NSUserDomainMask;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *array = [manager URLsForDirectory:searchPath inDomains:mask];
    NSURL *url = [array lastObject];
    return url;
}

+ (NSURL *)applicationDirectoryURL{
    NSSearchPathDirectory searchPath = NSApplicationDirectory;
    NSURL *url = [self.class directoryBySearchPath:searchPath];
    return url;
}

+ (NSURL *)documentDirectoryURL{
    NSSearchPathDirectory searchPath = NSDocumentDirectory;
    NSURL *url = [self.class directoryBySearchPath:searchPath];
    return url;
}

+ (NSString *)documentDirectoryString {
    NSURL *url = [self.class documentDirectoryURL];
    NSString *string = [url absoluteString];
    return string;
}

+ (NSString *)applicationDirectoryString {
    NSURL *url = [self.class applicationDirectoryURL];
    NSString *string = [url absoluteString];
    return string;
}

@end
