//
//  AppDelegate.m
//  Location
//
//  Created by cirrus on 29/11/12.
//  Copyright (c) 2012 cirrus. All rights reserved.
//  http://opensource.apple.com/source/configd/configd-204/scselect.tproj/scselect.c

#import "AppDelegate.h"
#import <SystemConfiguration/SystemConfiguration.h>

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSString *changeToSet = [[[[[NSBundle mainBundle] bundlePath] stringByDeletingPathExtension] componentsSeparatedByString:@"/"] lastObject];
    SCNetworkSetRef newSet = nil;
    
    SCPreferencesRef prefs = SCPreferencesCreate(NULL, CFSTR("Select Set Command"), NULL);
    NSArray *sets = [NSArray arrayWithArray:CFBridgingRelease(SCNetworkSetCopyAll(prefs))];
    SCNetworkSetRef currentSet = SCNetworkSetCopyCurrent(prefs);
    NSString *current = CFBridgingRelease(SCNetworkSetGetName(currentSet));
    NSLog(@"Current: %@", current);
    if([current isEqualToString:changeToSet]) {
        NSLog(@"Already in this set. Exiting...");
        [NSApp terminate:self];
    }
    for(id set in sets) {
        if([changeToSet isEqualToString:CFBridgingRelease(SCNetworkSetGetName((SCNetworkSetRef)CFBridgingRetain(set)))]) {
            newSet = CFBridgingRetain(set);
            break;
        }
    }
    if(!newSet)
    {
        NSLog(@"New set was not found. Exiting...");
        [NSApp terminate:self];
    }
    NSLog(@"%@",newSet);
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: @"/usr/sbin/scselect"];
    [task setArguments: [NSArray arrayWithObjects:changeToSet, nil]];
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    [task launch];
    
    /* 
    if(SCNetworkSetSetCurrent(newSet))
    {
        NSLog(@"Set was changed");
    } else {
        NSLog(@"Could not change set...");
    }
    if(SCPreferencesUnlock(prefs))
		NSLog(@"prefs unlock!");
	else {
		NSLog(@"prefs NOT unlocked!");
	}
    if(SCPreferencesCommitChanges(prefs))
		NSLog(@"Pref changes commited!");
	else {
		NSLog(@"Pref changes NOT commited!");
	}
	if(SCPreferencesApplyChanges(prefs))
		NSLog(@"Pref changes applied!");
	else {
		NSLog(@"Pref changes NOT applied!");
	}
    */
    
    [NSApp terminate:self];
    
}

@end
