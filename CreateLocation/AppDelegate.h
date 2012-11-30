//
//  AppDelegate.h
//  CreateLocation
//
//  Created by cirrus on 29/11/12.
//  Copyright (c) 2012 cirrus. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet NSButton *button;
}

@property (assign) IBOutlet NSPanel *window;

-(IBAction)buttonClicked:(id)sender;
-(void)windowWillClose:(NSNotification *)aNotification;

@end
