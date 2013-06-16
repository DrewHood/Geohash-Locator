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
    BOOL showMultipleHashes;
    
    IBOutlet MKMapView * mapView;
    IBOutlet NSDatePicker * datePicker;
    IBOutlet NSSegmentedControl * mapTypeSeg;
    IBOutlet NSButton * clearMapButton;
    IBOutlet NSPopUpButton * showPopUp;
}

/* Properties *\
\**************/

@property (nonatomic) BOOL showMultipleHashes;
@property (nonatomic, retain) IBOutlet MKMapView * mapView;
@property (nonatomic, retain) IBOutlet NSDatePicker * datePicker;
@property (nonatomic, retain) IBOutlet NSSegmentedControl * mapTypeSeg;
@property (nonatomic, retain) IBOutlet NSButton * clearMapButton;
@property (nonatomic, retain) IBOutlet NSPopUpButton * showPopUp;

/* Methods *\
\***********/

// Init
-(void) windowDidLoad;

// View Management
-(void) plotGeohash;

// User Interaction
-(IBAction) datePickerAction: (id) sender;
-(IBAction) mapTypeAction: (id) sender;
-(IBAction) clearMap: (id) sender;
-(IBAction) showPopUpAction: (id) sender;

// Location Update Handling
-(void) locationTrackingDidStop;
-(void) locationDidUpdate;

@end
