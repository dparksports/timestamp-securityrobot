//
//  MJMemoryManager.m
//  MJLibrary
//
//  Created by Dan Park on 8/24/14.
//  Copyright (c) 2014 Magic Point. All rights reserved.
//

#import "MJMemoryManager.h"
#import "mach/mach.h"

@implementation MJMemoryManager

static long prevMemUsage = 0;
static long curMemUsage = 0;
static long memUsageDiff = 0;
static long curFreeMem = 0;

+(vm_size_t) freeMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t pagesize;
    vm_statistics_data_t vm_stat;
    
    host_page_size(host_port, &pagesize);
    (void) host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    return vm_stat.free_count * pagesize;
}

+(vm_size_t) usedMemory {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
    return (kerr == KERN_SUCCESS) ? info.resident_size : 0; // size in bytes
}

+(float) usedMemoryInMB {
    vm_size_t  usedSizeType = [self usedMemory];
    unsigned long usedBytes = (unsigned long) usedSizeType;
    unsigned long usedInKB = usedBytes / 1024;
    float usedInMB = usedInKB / 1024.0;
    
//    NSLog(@"%s:usedSizeType:%@", __func__, @(usedSizeType));
//    NSLog(@"%s:usedBytes:%@", __func__, @(usedBytes));
    NSLog(@"%s:usedInKB:%@", __func__, @(usedInKB));
//    NSLog(@"%s:usedInMB:%@", __func__, @(usedInMB));
    return usedInMB;
}

+(NSUInteger) usedMemoryInKB {
    vm_size_t  usedSizeType = [self usedMemory];
    unsigned long usedBytes = (unsigned long) usedSizeType;
    NSUInteger usedInKB = usedBytes / 1024;
    return usedInKB;
}

+(void) captureMemUsage {
    prevMemUsage = curMemUsage;
    curMemUsage = [self usedMemory];
    memUsageDiff = curMemUsage - prevMemUsage;
    curFreeMem = [self freeMemory];
}

+(NSString*) captureMemUsageGetString{
    return [self captureMemUsageGetString: @"Mem:used %7.1f (%+5.0f), free %7.1f kb"];
}

+(NSString*) captureMemUsageGetString:(NSString*) formatstring {
    [self captureMemUsage];
    return [NSString stringWithFormat:formatstring,curMemUsage/1000.0f, memUsageDiff/1000.0f, curFreeMem/1000.0f];
}
@end
