//
//  NSTask+ProcessString.m
//  cocoa-interpreter
//
//  Created by Dominik Pich on 7/9/12.
//  Copyright (c) 2012 info.pich. All rights reserved.
//

#import "NSTask+ProcessString.h"
#import "DDEmbeddedDataReader.h"
#import "defines.h"

@implementation NSTask (ProcessString)


+ (NSInteger)processString:(NSMutableString*)objC {
    NSRange rStart, rEnd; //ranges of `
    NSUInteger c = 0; //number of entries found & replaced
    
    //find backtick strings and call runner method
    while((rStart = [objC rangeOfString:@"`"]).length!=0
          && rStart.location<objC.length-1) {
        //find next `
        rEnd = NSMakeRange(rStart.location+rStart.length,
                           objC.length-(rStart.location+rStart.length));
        rEnd = [objC rangeOfString:@"`" options:0 range:rEnd];

        if(!rEnd.length) {
            printf("unterminated backtick");
            return -1;
        }

        NSRange rCmd = NSMakeRange(rStart.location+rStart.length, (rEnd.location-1)
                                   -(rStart.location+rStart.length-1));
        
        NSString *command = [objC substringWithRange:rCmd];

        //write it out and correct indices
        [objC replaceCharactersInRange:rStart withString:TASK_RUNSTRING_START];
        rCmd.location = rStart.location + TASK_RUNSTRING_START.length;
        [objC replaceCharactersInRange:rCmd withString:command];
        rEnd.location = rCmd.location + command.length;
        [objC replaceCharactersInRange:rEnd withString:TASK_RUNSTRING_END];
        
        c++;
    }
    
    //add task runner method if needed
    if(c) {
        NSData *d = [DDEmbeddedDataReader embeddedDataFromSection:@"__runTask" error:nil];
        NSString *s = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
        NSAssert(s.length>0, @"The RunTask code couldnt be loaded.");
        
        
        NSRange r = [objC rangeOfString:MAIN_OPEN];
        [objC insertString:s atIndex:r.location];
    }
    
    return c;
}

@end
