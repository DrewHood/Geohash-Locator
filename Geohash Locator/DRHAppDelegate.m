//
//  DRHAppDelegate.m
//  Geohash Locator
//
//  Created by Drew R. Hood on 6/15/13.
//  Copyright (c) 2013 Drew R. Hood. All rights reserved.
//

#import "DRHAppDelegate.h"

// Globals
static DRHAppDelegate * kSharedAppDelegate;

@implementation DRHAppDelegate

/* Properties *\
\**************/

/* Methods *\
\***********/

// App Init
-(void) applicationDidFinishLaunching: (NSNotification *) aNotification
{
    NSLog(@"Hello! Is this the cemetery? Y'all need to come get this old bastard. He's starting to freak me out.");
    
    kSharedAppDelegate = self;
    
    window = [[DRHMainWindow_WindowController alloc] initWithWindowNibName: @"DRHMainWindow_WindowController"];
    
    [window showWindow: self];
    
    // Start the tracker.
    DRHGeohashLocator * locator = [DRHGeohashLocator sharedLocator];
    
    [locator startTracking];
}

-(BOOL) applicationShouldTerminateAfterLastWindowClosed: (NSApplication *) sender
{
    return YES;
}

-(void) applicationWillTerminate: (NSNotification *) notification
{
    if ( [DRHGeohashLocator sharedLocator].tracking )
        [[DRHGeohashLocator sharedLocator] stopTracking];
    
    NSLog(@"Byeee!");
}

// Meta
+(DRHAppDelegate *) sharedDelegate
{
    return kSharedAppDelegate;
}

@end
