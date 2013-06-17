//
//  DRHMainWindow_WindowController.m
//  Geohash Locator
//
//  Created by Drew R. Hood on 6/15/13.
//  Copyright (c) 2013 Drew R. Hood. All rights reserved.
//

#import "DRHMainWindow_WindowController.h"

@implementation DRHMainWindow_WindowController

/* Properties *\
\**************/

@synthesize showMultipleHashes, listenForUpdates, windowIsResizing;
@synthesize mapView;
@synthesize datePicker;
@synthesize mapTypeSeg;
@synthesize clearMapButton, recenterButton;
@synthesize showPopUp;

/* Methods *\
\***********/

// Init
-(void) windowDidLoad
{
    [super windowDidLoad];
    
    // Sign up for window resize notifications.
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(windowWillStartResize) name: NSWindowWillStartLiveResizeNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(windowWillStartResize) name: NSWindowWillEnterFullScreenNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(windowDidEndResize) name: NSWindowDidEndLiveResizeNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(windowDidEndResize) name: NSWindowDidEnterFullScreenNotification object: nil];
    
    self.showMultipleHashes = TRUE;
    
    [showPopUp selectItemAtIndex: (int) showMultipleHashes];
    
    // Set default date.
    [datePicker setDateValue: [NSDate date]];
    [datePicker setMaxDate: [NSDate date]];
    
    // Set up map.
    mapView.showsZoomControls = TRUE;
    mapView.showsCompass = TRUE;
    mapView.mapType = MKMapTypeStandard;
    mapView.showsUserLocation = TRUE;
    mapView.delegate = self;
    
    // If we can't use location, disable My Location button.
    [recenterButton setEnabled: [DRHGeohashLocator sharedLocator].canTrack];
    
    // Sign up for location notifications
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(locationTrackingDidStart) name: kLocationManagerDidStartTrackingNotification object:[DRHGeohashLocator sharedLocator]];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(centerMapOnCoordinates:) name: kLocationManagerDidUpdateLocationNotification object: [DRHGeohashLocator sharedLocator]];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(locationTrackingDidStop) name: kLocationManagerDidStopTrackingNotification object: [DRHGeohashLocator sharedLocator]];
}

// View Management
-(void) setListenForUpdates: (BOOL) listen
{
    listenForUpdates = listen;
    
    if ( listenForUpdates )
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(centerMapOnCoordinates:) name: kLocationManagerDidUpdateLocationNotification object: [DRHGeohashLocator sharedLocator]];
    else
        [[NSNotificationCenter defaultCenter] removeObserver: self name: kLocationManagerDidUpdateLocationNotification object: [DRHGeohashLocator sharedLocator]];
}

-(void) plotGeohash
{
    // Clear the map if needed.
    if ( !showMultipleHashes )
        [self clearMap: nil];
    
    // Extract the map coords.
    CLLocationCoordinate2D coords = mapView.region.center;
    
    // Now grab the hash coords.
    CLLocationCoordinate2D hashCoords = [[DRHGeohashLocator sharedLocator] retrieveHashForLat: coords.latitude andLon: coords.longitude forDate: datePicker.dateValue];
    
    // If it's already plotted, stop here.
    if ( [mapView.annotations count] > 0 ) {
        
        for ( int i = 0; i < [mapView.annotations count]; i++ ) {
            
            CLLocationCoordinate2D shownCoord = [[mapView.annotations objectAtIndex: i] coordinate];
            
            if ( shownCoord.latitude == hashCoords.latitude && shownCoord.longitude == hashCoords.longitude )
                return;
            
        }
        
    }
    
    // If the points are invalid, we're done.
    if ( hashCoords.latitude == -1000 && hashCoords.longitude == -1000 )
        return;
    
    // Create an annotation.
    MKPointAnnotation * point = [[MKPointAnnotation alloc] init];
    point.coordinate = hashCoords;
    
    // And add it to the map.
    [mapView addAnnotation: point];
}

// User Interaction
-(IBAction) datePickerAction: (id) sender
{
    // Log the date.
    NSLog(@"Date selected: %@", [[datePicker dateValue] description]);
    
    [self plotGeohash];
}

-(IBAction) mapTypeAction: (id) sender
{
    // Set the map type.
    mapView.mapType = [sender selectedSegment];
}

-(IBAction) clearMap: (id) sender
{
    [mapView removeAnnotations: mapView.annotations];
    
    mapView.showsUserLocation = TRUE;
}

-(IBAction) showPopUpAction: (id) sender
{
    [self clearMap: nil];
    
    self.showMultipleHashes = (BOOL) [showPopUp indexOfSelectedItem];
    
    [self plotGeohash];
}

-(IBAction) recenterAction: (id) sender
{
    [self centerMapOnCoordinates: nil];
}

// Location Update Handling
-(void) locationTrackingDidStart
{
    [recenterButton setEnabled: [DRHGeohashLocator sharedLocator].canTrack];
}

-(void) locationTrackingDidStop
{
    NSLog(@"Where'd you go?");
    
    [recenterButton setEnabled: NO];
}

-(void) centerMapOnCoordinates: (id) var
{
    // Extract the coords.
    CLLocationCoordinate2D coords;
    
    // If they're given to us as var, use that, otherwise use user location.
    BOOL userLoc = FALSE;
    
    if ( var != nil ) {
        
        if ( [var isKindOfClass: [CLLocation class]] && [var respondsToSelector: @selector(coordinate)] )
            coords = [var coordinate];
        else if ( [var isKindOfClass: [CLLocationManager class]] && [var respondsToSelector: @selector(location)] ) {
            
            CLLocationManager * var = var;
            
            coords = [var location].coordinate;
            
        } else if ( [var isKindOfClass: [DRHGeohashLocator class]] && [var respondsToSelector: @selector(locationManager)] )
            coords = [[[var locationManager] location] coordinate];
        else {
            
            userLoc = TRUE;
            coords = [[[[DRHGeohashLocator sharedLocator] locationManager] location] coordinate];
            
        }
        
    } else {
        
        userLoc = TRUE;
        coords = [[[[DRHGeohashLocator sharedLocator] locationManager] location] coordinate];
        
    }
    
    // We want to center on the graticule, not the location given, so we need to do some math.
    CLLocationDegrees lat = coords.latitude;
    CLLocationDegrees lon = coords.longitude;
    
    lat = floor(lat);
    lon = floor(lon);
    
    lat = lat + 0.5;
    lon = lon + 0.5;
    
    coords.latitude = lat;
    coords.longitude = lon;
    
    // Create the span.
    MKCoordinateSpan span;
    span.latitudeDelta = 1.25;
    span.longitudeDelta = 1.25;
    
    // Build the region.
    MKCoordinateRegion region;
    region.center = coords;
    region.span = span;
    
    // Center!
    [mapView setRegion: region animated: YES];
    
    // If we used the user location, stop updating for that.
    if ( userLoc )
        [self setListenForUpdates: FALSE];
}

/* Window Delegation *\
\*********************/

// Resizing
-(void) windowWillStartResize
{
    windowIsResizing = TRUE;
    
    NSLog(@"Window resizing...");
}

-(void) windowDidEndResize
{
    windowIsResizing = FALSE;
    
    NSLog(@"Window resized.");
    
    [self plotGeohash];
}

/* Map View Delegation *\
\***********************/

-(void) mapView: (MKMapView *) map regionDidChangeAnimated: (BOOL) animated
{
    if ( windowIsResizing )
        return;
    
    [self plotGeohash];
}

@end