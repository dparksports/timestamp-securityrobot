//
//  MJDebugHeader.h
//  MJLibrary
//
//  Created by Dan Park on 8/26/14.
//  Copyright (c) 2014 Magic Point. All rights reserved.
//

#ifndef MJLibrary_MJDebugHeader_h
#define MJLibrary_MJDebugHeader_h

#ifdef DEBUG
#	define DLOG(fmt, ...) NSLog((@"%s" fmt), __PRETTY_FUNCTION__, ##__VA_ARGS__);
#else
#	define DLOG(...)
#endif
// app logging macro, use this for general app logging, outputs in both debug and release builds
#define ALOG(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#endif
