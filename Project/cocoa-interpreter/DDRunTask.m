//
//  DDRunTask.c
//  cocoa-interpreter
//
//  Created by Dominik Pich on 7/15/12.
//  Copyright (c) 2012 info.pich. All rights reserved.
//
NSString *DDRunTask(NSString *command, ...);
NSString *DDRunTask(NSString *command, ...) {
    //var args to string array
    va_list varargs;
    va_start(varargs, command);
    id arg = nil;
    NSMutableArray *args = [NSMutableArray array];
    while ((arg = va_arg(varargs,id))) {
        id argString = [[arg description] stringByExpandingTildeInPath];
        [args addObject:argString];
    }
    va_end(varargs);
    
    //add env if needed
    if(![command hasPrefix:@"./"] && ![command hasPrefix:@"/"]) {
        [args insertObject:command atIndex:0];
        command = @"/usr/bin/env";
    }
    
    //setup task and run it - reading its stdout
    @autoreleasepool {
        NSMutableData *readData = [[NSMutableData alloc] init];
        NSPipe *pipe = [NSPipe pipe];
        NSFileHandle *fileHandle = [pipe fileHandleForReading];
        NSData *data = nil;
        NSTask *task = [[NSTask alloc] init];
        [task setLaunchPath:command];
        if(args.count) {
            [task setArguments:args];
        }
        [task setStandardOutput: pipe];
        [readData setLength:0];
        [task launch];
        while ((task != nil) && ([task isRunning]))	{
            data = [fileHandle availableData];
            [readData appendData:data];
        }
        return [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    }
    return nil;
}