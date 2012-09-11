cocoa-interpreter
==============

cocoa-interpreter allows you to use objective C as a shell scripting language.

so you can write scripts like the included DemoScript that dont need an include of cocoa, a main function or an autoreleasepool (thanks to ARC you dont need to worry about retsin/release for cocoa objects):
	
	#!cocoa-interpreter
	
    //check params
    if(args.count != 1) {
	    NSLog(@"This DemoScript need to be given a path to a PNG file thats 512x512 which it turns into an icns file"); 
	    return -1;
    }
	    
    //print all command line args (the args array is automatically set)
    NSArray *testArray = [args copy];
    for(id s in testArray) {
        NSLog(@"arg: %@",s);
    }
    
	...
	
    //use filemgr
    id attribs =  [[NSFileManager defaultManager] attributesOfItemAtPath:programPath error:nil];
    NSDate *modDate = [attribs fileModificationDate];
    
    //run alert
    NSUInteger ret = NSRunAlertPanel(@"modDat"e, [modDate description], @"OK", nil, nil);
    
    //convert img to icon
	...	

##installation and usage
	    
The included installer package (under Downloads) will copy the 64bit executable of cocoa-interpretr to _/usr/bin/_ so that in shell scripts we can reference it as a shell interpreter. IF you move it to a different path, you have to specify that path in your script. e.g.:
 
	#!/usr/local/bin/cocoa-interpreter
	
Alternatively you can also invoke it and pass it a path TO a script

	~:: cocoa-interpreter <PATH_TO_FILE>

##license
the code is available under the MIT license