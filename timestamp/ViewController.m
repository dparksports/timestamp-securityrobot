//
//  ViewController.m
//  timestamp
//
//  Created by 5dof on 12/4/19.
//  Copyright © 2019 5dof. All rights reserved.
//

#import "ViewController.h"
#import "MJLogFileManager.h"
#import "MJStatusManager.h"

@interface ViewController ()
@property (nonatomic, strong) NSString *drawString1, *drawString2;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController {
    BOOL isPlanar;
    size_t bytesPerRow;
    size_t width;
    size_t height;
    CGSize size;
    CVPixelBufferRef pixelBuffer;
    CGColorSpaceRef colorSpace;
    CTFontRef fontRef;
    CGFloat fontSize;

    volatile BOOL updateDrawString1;
    const char *cDrawString1, *cDrawString2;
    char drawStringArray1[100], drawStringArray2[100];
    size_t drawStringLength1, drawStringLength2;
    CGFloat yOffsetDrawString;
    
    BOOL drawText;
    NSUInteger countStatus;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initStatusText];
    [self updateStatus];
}

#pragma mark - Status

- (void)initStatusText {
    NSDate *date = [NSDate date];
    NSLog(@"%s: date:%@", __func__, date);
    [[MJStatusManager sharedManager] setStartTimestamp:date];
}

- (void)initDrawStrings{
    MJStatusManager *manager = [MJStatusManager sharedManager];
    NSString *elapsedTimeString = [manager elapsedTimeString];
    NSString *batteryLevelString = [manager batteryLevelString];
    NSString *usedMemoryInKBString = [manager usedMemoryInKBString];
    NSString *dropLabelString = [NSString stringWithFormat:@"%@/m", @(0)];
    
    NSString *timestamp = [PHCalendarCalculate timestampInShortShortFormat];
    NSString *statusString = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",
                        timestamp, elapsedTimeString, batteryLevelString, dropLabelString, usedMemoryInKBString];
    [self setDrawString1:statusString];
    [self setDrawString2:statusString];
    NSUInteger length = [self.drawString1 lengthOfBytesUsingEncoding:NSASCIIStringEncoding];
    drawStringLength1 = (size_t) length;
    drawStringLength2 = (size_t) length;
    cDrawString1 = [self.drawString1 cStringUsingEncoding:NSASCIIStringEncoding];
    cDrawString2 = [self.drawString2 cStringUsingEncoding:NSASCIIStringEncoding];
    if (cDrawString1) {
        memset(&drawStringArray1, 0, sizeof(drawStringArray1));
        memcpy(&drawStringArray1, cDrawString1, drawStringLength1);
    }
    if (cDrawString2) {
        memset(&drawStringArray2, 0, sizeof(drawStringArray2));
        memcpy(&drawStringArray2, cDrawString2, drawStringLength2);
    }
    
    NSLog(@"%s: length:%ld, drawStringLength2:%zu, string: %s",
          __func__, (unsigned long)length, drawStringLength2, drawStringArray1);
}

- (void)drawTextInContext:(CGContextRef)context{
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    CGContextSelectFont(context, "Helvetica", fontSize, kCGEncodingMacRoman);
    switch (deviceOrientation) {
        case UIDeviceOrientationLandscapeRight: {
            CGFloat tx = size.width * 1.0;
            CGFloat ty = size.height * (28/30.0);
            CGContextTranslateCTM(context, tx,ty);
            
            CGFloat degrees = 180;
            CGFloat angleInRadians = degrees * M_PI/180.0;
            CGContextRotateCTM(context, angleInRadians);
        }
            break;
        case UIDeviceOrientationLandscapeLeft: {
            CGFloat degrees = 0;
            CGFloat angleInRadians = degrees * M_PI/180.0;
            CGContextRotateCTM(context, angleInRadians);
        }
            break;
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationUnknown:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
        default: {
            CGFloat tx = size.width * (19/20.0);
            CGFloat ty = size.height * 0;
            CGContextTranslateCTM(context, tx,ty);
            
            CGFloat degrees = 90;
            CGFloat angleInRadians = degrees * M_PI/180.0;
            CGContextRotateCTM(context, angleInRadians);
        }
            break;
        case AVCaptureVideoOrientationPortraitUpsideDown :{
            CGFloat degrees = -90.;
            CGFloat angleInRadians = degrees * M_PI/180.0;
            CGContextRotateCTM(context, angleInRadians);
        }
            break;
            break;
    }
    
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1.0);
    CGContextSetRGBFillColor(context, 1, 1, 1, 1.0);
    CGContextSetTextDrawingMode(context, kCGTextFillStroke);
    if (updateDrawString1)
        CGContextShowTextAtPoint(context, 0, yOffsetDrawString, drawStringArray2, drawStringLength2);
    else
        CGContextShowTextAtPoint(context, 0, yOffsetDrawString, drawStringArray1, drawStringLength1);
}

- (void)updateStatus {
    MJStatusManager *manager = [MJStatusManager sharedManager];
    NSString *elapsedTimeString = [manager elapsedTimeString];
    NSString *batteryLevelString = [manager batteryLevelString];
    NSString *usedMemoryInKBString = [manager usedMemoryInKBString];
    NSString *dropLabelString = [NSString stringWithFormat:@"%@/m", @(0)];
    
//    NSString *sessionPreset = self.captureSession.sessionPreset;
//    NSString *dimensionLabelString = [NSString stringWithFormat:@"%@, 1/%d",
//                           [MJCaptureSessionPreset sizeStringByPreset:sessionPreset],
//                           frameDuration.timescale];
    
    NSString *timestamp = [PHCalendarCalculate timestampInShortShortFormat];
    NSString *statusString = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",
                        timestamp, elapsedTimeString, batteryLevelString, dropLabelString, usedMemoryInKBString];
    
    updateDrawString1 = ! updateDrawString1;
    if (updateDrawString1) {
        [self setDrawString1:statusString];
        NSUInteger length = [self.drawString1 lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        drawStringLength1 = (size_t) length;
        cDrawString1 = [self.drawString1 cStringUsingEncoding:NSUTF8StringEncoding];
        if (cDrawString1) {
            memset(&drawStringArray1, 0, sizeof(drawStringArray1));
            memcpy(&drawStringArray1, cDrawString1, drawStringLength1);
        }
    } else {
        [self setDrawString2:statusString];
        NSUInteger length = [self.drawString2 lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        drawStringLength2 = (size_t) length;
        cDrawString2 = [self.drawString2 cStringUsingEncoding:NSUTF8StringEncoding];
        if (cDrawString2) {
            memset(&drawStringArray2, 0, sizeof(drawStringArray2));
            memcpy(&drawStringArray2, cDrawString2, drawStringLength2);
        }
    }
    
    yOffsetDrawString = fontSize * (1*3/4.0); // 3/4.0
    
    if (! self.timer) {
        NSTimeInterval interval = 3.0; // 1
        SEL sel = @selector(updateTimer:);
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:sel userInfo:nil repeats:YES];
        [self setTimer:timer];
    }
    
    NSString *string = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        string = [manager description];
    else
        string = [manager descriptionWithTimestamp];
    [MJLogFileManager logStringToFile:string file:@"log.txt"];
    
    if (countStatus % 60 == 0) {
    }
    if (countStatus % 60 >= 10) {
        drawText = YES;
    } else {
        drawText = NO;
    }
    countStatus++;
}

- (void)updateTimer:(NSTimer *)timer {
    [self updateStatus];
}

- (void) captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
    if (drawText) {
        pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer);
        width = CVPixelBufferGetWidth(pixelBuffer);
        height = CVPixelBufferGetHeight(pixelBuffer);
        size = CGSizeMake(width, height);
        isPlanar = CVPixelBufferIsPlanar(pixelBuffer);
        
        if (! isPlanar) {
            CVPixelBufferLockBaseAddress(pixelBuffer, kCVPixelBufferLock_ReadOnly);
            void *sourceBaseAddr = (uint8_t *)CVPixelBufferGetBaseAddress(pixelBuffer);
            CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst;
            CGContextRef contextRef = CGBitmapContextCreate(sourceBaseAddr, width, height, 8, bytesPerRow, colorSpace, bitmapInfo);
            [self drawTextInContext:contextRef];
            CVPixelBufferUnlockBaseAddress(pixelBuffer, kCVPixelBufferLock_ReadOnly);
            CGContextRelease(contextRef);
        }
    }
}


@end
