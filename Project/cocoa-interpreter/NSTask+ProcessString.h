//
//  NSTask+ProcessString.h
//  cocoa-interpreter
//
//  Created by Dominik Pich on 7/9/12.
//  Copyright (c) 2012 info.pich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTask (ProcessString)

+ (NSInteger)processString:(NSMutableString*)objC;

@end
