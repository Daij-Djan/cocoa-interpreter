//
//  NSTask+Clang.h
//  cocoa-interpreter
//
//  Created by Dominik Pich on 7/5/12.
//  Copyright (c) 2012 info.pich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTask (Clang)

+ (NSTask*)clangForFile:(NSString*)in outputTo:(NSString*)out;

@end
