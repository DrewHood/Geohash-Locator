//
//  DRHMainWindow_WindowController.h
//  Geohash Locator
//
//  Created by Drew R. Hood on 6/15/13.
//  Copyright (c) 2013 Drew R. Hood. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DRHMainWindow_WindowController : NSWindowController <MKMapViewDelegate, NSWindowDelegate>
{
    BOOL showMultipleHashes, listenForUpdates, windowIsResizing;
    
    IBOutlet MKMapView * mapView;
    IBOutlet NSDatePicker * datePicker;
    IBOutlet NSSegmentedControl * mapTypeSeg;
    IBOutlet NSButton * clearMapButton, * recenterButton, * todaysHashButton;
    IBOutlet NSPopUpButton * showPopUp;
}

/* Properties *\
\**************/

@property (nonatomic) BOOL showMultipleHashes, listenForUpdates, windowIsResizing;
@property (nonatomic, retain) IBOutlet MKMapView * mapView;
@property (nonatomic, retain) IBOutlet NSDatePicker * datePicker;
@property (nonatomic, retain) IBOutlet NSSegmentedControl * mapTypeSeg;
@property (nonatomic, retain) IBOutlet NSButton * clearMapButton, * recenterButton, * todaysHashButton;
@property (nonatomic, retain) IBOutlet NSPopUpButton * showPopUp;

/* Methods *\
\***********/

// Init
-(void) windowDidLoad;

// View Management
-(void) setListenForUpdates: (BOOL) listen;
-(void) plotGeohash;

// User Interaction
-(IBAction) datePickerAction: (id) sender;
-(IBAction) mapTypeAction: (id) sender;
-(IBAction) clearMap: (id) sender;
-(IBAction) showPopUpAction: (id) sender;
-(IBAction) recenterAction: (id) sender;
-(IBAction) todaysHashAction: (id) sender;

// Location Update Handling
-(void) locationTrackingDidStart;
-(void) locationTrackingDidStop;
-(void) centerMapOnCoordinates: (id) var;

/* Window Delegation *\
\*********************/

// Resizing
-(void) windowWillStartResize;
-(void) windowDidEndResize;

/* Map View Delegation *\
\***********************/

-(void) mapView: (MKMapView *) map regionDidChangeAnimated: (BOOL) animated;

@end