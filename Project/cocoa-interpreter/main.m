//
//  main.m
//  cocoa-interpreter
//
//  Created by Dominik Pich on 7/4/12.
//  Copyright (c) 2012 info.pich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDChecksum.h"
#import "NSTask+Clang.h"

#define INTERPRETER_ARGS_COUNT 2

#define MAIN_OPEN @"int main(int argc, const char * argv[]) { @autoreleasepool {\n"
#define IMPORT_COCOA @"#import <Cocoa/Cocoa.h>\n"
#define MAIN_CLOSE @"\n} return 0; }"
#define ARGS_OPEN @"\nNSArray *args = [NSArray arrayWithObjects:"
#define ARGS_CLOSE @"nil];\n"
#define EMPTY_ARGS @"\nNSArray *args = [NSArray array];"

//---

//call clang
int compile(NSMutableString *objC, NSStringEncoding encoding, NSString **file) {
    //get md5
    NSData *data  = [objC dataUsingEncoding:encoding];
    NSString *md5 = [DDChecksum checksum:DDChecksumTypeMD5 forData:data];

    //get paths
    NSString *temp = NSTemporaryDirectory();
    NSString *in = [[temp stringByAppendingPathComponent:md5] stringByAppendingPathExtension:@"m"];
    NSString *out = [temp stringByAppendingPathComponent:md5];
    *file = out;
    
    //see if we have in and out
    if([[NSFileManager defaultManager] fileExistsAtPath:in] &&
       [[NSFileManager defaultManager] fileExistsAtPath:out]) {
        data = [NSData dataWithContentsOfFile:in];
        NSString *oldMd5 = [DDChecksum checksum:DDChecksumTypeMD5 forData:data];
        
        if([oldMd5 isEqualToString:md5]) {
            //all up to date
            return 0;
        }
    }

    //write it right now
    [objC writeToFile:in atomically:YES encoding:encoding error:nil];

    //call clang
    NSTask *task = [NSTask clangForFile:in outputTo:out];
    [task waitUntilExit];
    return [task terminationStatus];
}

//preprare script
int prepare(NSMutableString *objC, NSStringEncoding encoding, NSString *scriptArgs) {
    //modify script by removing interpreter
    NSRange range = [objC rangeOfString:@"\n"];
    if(range.location == NSNotFound) {
        printf("no newline after interpreter line");
        return -2;
    }
    NSUInteger index = range.location;
    if(index >= objC.length) {
        printf("empty script file");
        return -3;
    }
    [objC deleteCharactersInRange:NSMakeRange(0, index)];
        
    //add main body
    [objC insertString:scriptArgs?scriptArgs:EMPTY_ARGS atIndex:0];
    [objC insertString:MAIN_OPEN atIndex:0];
    [objC insertString:IMPORT_COCOA atIndex:0];
    [objC appendString:MAIN_CLOSE];
    
    return 0;
}

//entry point
int main(int argc, const char * argv[])
{
    if(argc<INTERPRETER_ARGS_COUNT) {
        printf("Usage: cocoa-interpreter FILE [args] or embed #!<PATHT_TO_cocoa-interpreter> in your objective-C shell script");
        return -1;
    }
    
    @autoreleasepool {
        //open file
        NSStringEncoding encoding = 0;
        NSError *error = nil;
        NSMutableString *objC = [NSMutableString stringWithContentsOfFile:@(argv[1]) usedEncoding:&encoding error:&error];
        if(!objC.length) {
            printf("cocoa-interpreter failed to read script at %s. File not found or bad encoding %ld", argv[1], encoding);
            if(error) {
                printf("Underlying error: %s", error.description.UTF8String);
            }
            return -1;
        }
        
        //collect script args
        NSMutableString *scriptArgs = nil;
        if(argc>INTERPRETER_ARGS_COUNT) {
            scriptArgs = [NSMutableString stringWithString:ARGS_OPEN];
            for(int i = INTERPRETER_ARGS_COUNT; i < argc; i++) {
                [scriptArgs appendFormat:@"@\"%s\", ", argv[i]];
            }
            [scriptArgs appendString:ARGS_CLOSE];
        }
        int res = prepare(objC, encoding, scriptArgs);
        if(res!=0) {
            printf("Preparation (adding includes, main method, arguments array) of script failed");
            return res;
        }
        
        NSString *path = nil;
        res = compile(objC, encoding, &path);
        if(res!=0) {
            printf("Compilation of script failed");
            return res;
        }
        
        NSTask *task = [NSTask launchedTaskWithLaunchPath:path arguments:[NSArray array]];
        [task waitUntilExit];
        res = task.terminationStatus;
        if(res!=0) {
//            printf(@"Script was executed but failed: %d", res);
            return res;
        }
    }
    return 0;
}

