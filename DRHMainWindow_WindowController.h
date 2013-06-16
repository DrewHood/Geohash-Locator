//
//  DRHMainWindow_WindowController.h
//  Geohash Locator
//
//  Created by Drew R. Hood on 6/15/13.
//  Copyright (c) 2013 Drew R. Hood. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DRHMainWindow_WindowController : NSWindowController
{
    IBOutlet MKMapView * mapView;
    IBOutlet NSDatePicker * datePicker;
    IBOutlet NSSegmentedControl * mapTypeSeg;
}

/* Properties *\
\**************/

@property (nonatomic, retain) IBOutlet MKMapView * mapView;
@property (nonatomic, retain) IBOutlet NSDatePicker * datePicker;
@property (nonatomic, retain) IBOutlet NSSegmentedControl * mapTypeSeg;

/* Methods *\
\***********/

// Init
-(void) windowDidLoad;

// User Interaction
-(IBAction) datePickerAction: (id) sender;
-(IBAction) mapTypeAction: (id) sender;

// Location Update Handling
-(void) locationTrackingDidStop;
-(void) locationDidUpdate;

@end
