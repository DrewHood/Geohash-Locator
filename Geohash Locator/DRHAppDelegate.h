//
//  DRHAppDelegate.h
//  Geohash Locator
//
//  Created by Drew R. Hood on 6/15/13.
//  Copyright (c) 2013 Drew R. Hood. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DRHAppDelegate : NSObject <NSApplicationDelegate>
{
    // View
    DRHMainWindow_WindowController * window;
}

/* Properties *\
\**************/

/* Methods *\
\***********/

// App Init
-(void) applicationDidFinishLaunching: (NSNotification *) aNotification;
-(BOOL) applicationShouldTerminateAfterLastWindowClosed: (NSApplication *) sender;
-(void) applicationWillTerminate: (NSNotification *) notification;

// Meta
+(DRHAppDelegate *) sharedDelegate;

@end
