//
//  defines.h
//  cocoa-interpreter
//
//  Created by Dominik Pich on 7/9/12.
//  Copyright (c) 2012 info.pich. All rights reserved.
//
#define INTERPRETER_ARGS_COUNT 2

#define IMPORT_COCOA @"#import <Cocoa/Cocoa.h>\n"

#define MAIN_OPEN @"\nint main(int argc, const char * argv[]) { @autoreleasepool {\n"
#define MAIN_CLOSE @"\n} return 0; }"

#define PROGNAME @"\nNSString *progName = @\"%@\";"

#define ARGS_OPEN @"\nNSArray *args = [NSArray arrayWithObjects:"
#define ARGS_CLOSE @"nil];\n"
#define EMPTY_ARGS @"\nNSArray *args = [NSArray array];"

#define TASK_RUNSTRING_START @"DDRunTask("
#define TASK_RUNSTRING_END @", nil)"

//-sectcreate __TEXT __info_plist Info.plist_path
