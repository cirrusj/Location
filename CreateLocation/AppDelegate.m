//
//  AppDelegate.m
//  CreateLocation
//
//  Created by cirrus on 29/11/12.
//  Copyright (c) 2012 cirrus. All rights reserved.
//

#import "AppDelegate.h"
#import <SystemConfiguration/SystemConfiguration.h>

@implementation AppDelegate

- (void)showError:(NSString*)error
{
    CFStringRef title = (CFStringRef)@"Error";
    CFStringRef informativeText = (CFStringRef)CFBridgingRetain(error);
    CFOptionFlags options = kCFUserNotificationNoteAlertLevel;
    CFOptionFlags responseFlags = 0;
    CFUserNotificationDisplayAlert(0, options, NULL, NULL, NULL,
                                   title,
                                   informativeText, NULL,
                                   NULL,NULL, &responseFlags);
    CFRelease(informativeText);
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
}

-(void)windowWillClose:(NSNotification *)aNotification
{
    [NSApp terminate:self];
}

-(IBAction)buttonClicked:(id)sender
{
    [sender setEnabled:NO];
    [self create];
}

- (void) create
{
    NSURL *locationApp = [[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"Location.app"];
    NSURL *output = nil;
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setCanChooseFiles:NO];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setCanCreateDirectories:YES];
    if ( [openPanel runModal] == NSOKButton ) {
        output = [openPanel URL];
    } else {
        [button setEnabled:YES];
        return;
    }
    SCPreferencesRef prefs = SCPreferencesCreate(NULL, CFSTR("Select Set Command"), NULL);
    CFArrayRef CFsets = SCNetworkSetCopyAll(prefs);
    NSArray *sets = [NSArray arrayWithArray:CFBridgingRelease(CFsets)];
    NSMutableArray *locationNames = [[NSMutableArray alloc] init];
    for(id set in sets) {
        SCNetworkSetRef currentSet = CFBridgingRetain(set);
        NSString *loc = CFBridgingRelease(SCNetworkSetGetName(currentSet));
        NSString *newLocationApp = [loc stringByAppendingString:@".app"];
        NSURL *new = [output URLByAppendingPathComponent:newLocationApp];
        [locationNames addObject:new];
        CFRelease(currentSet);
    }
    NSLog(@"%@",locationNames);
    
    for(id location in locationNames) {
        NSError *derror;
        BOOL result = [[NSFileManager defaultManager] copyItemAtURL:locationApp toURL:location error:&derror];
        if(!result)
        {
            [self showError:[derror localizedDescription]];
        }
    }
    [[NSWorkspace sharedWorkspace] openURL:output];
    [NSApp terminate:self];
}

@end
