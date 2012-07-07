//
//  NSTask+Clang.m
//  cocoa-interpreter
//
//  Created by Dominik Pich on 7/5/12.
//  Copyright (c) 2012 info.pich. All rights reserved.
//

#import "NSTask+Clang.h"

@implementation NSTask (Clang)

+ (NSTask*)clangForFile:(NSString*)in outputTo:(NSString*)out {
    NSArray *args = @[@"-arch", @"x86_64", @"-fobjc-arc", @"-fasm-blocks", @"-fmessage-length=0", @"-std=gnu99", @"-fpascal-strings", @"-Os", @"-framework", @"Cocoa", @"-o", out, in];
    
    return [NSTask launchedTaskWithLaunchPath:@"/usr/bin/clang" arguments:args];
}

@end
