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

@synthesize mapView;
@synthesize datePicker;
@synthesize mapTypeSeg;

/* Methods *\
\***********/

// Init
-(void) windowDidLoad
{
    [super windowDidLoad];
    
    // Set default date.
    [datePicker setDateValue: [NSDate date]];
    
    // Set up map.
    mapView.showsZoomControls = TRUE;
    mapView.showsCompass = TRUE;
    mapView.mapType = MKMapTypeStandard;
    mapView.showsUserLocation = TRUE;
    
    // Sign up for location notifications.
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(locationDidUpdate) name: kLocationManagerDidUpdateLocationNotification object: [DRHGeohashLocator sharedLocator]];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(locationTrackingDidStop) name: kLocationManagerDidStopTrackingNotification object: [DRHGeohashLocator sharedLocator]];
}

// User Interaction
-(IBAction) datePickerAction: (id) sender
{
    // Log the date.
    NSLog(@"Date selected: %@", [[datePicker dateValue] description]);
}

-(IBAction) mapTypeAction: (id) sender
{
    // Set the map type.
    mapView.mapType = [sender selectedSegment];
}

// Location Update Handling
-(void) locationTrackingDidStop
{
    NSLog(@"Where'd you go?");
}

-(void) locationDidUpdate
{
    NSLog(@"I heard you're here: %@", [[DRHGeohashLocator sharedLocator].locationManager.location description]);
    
    // Extract the coords.
    CLLocationCoordinate2D coords = [[DRHGeohashLocator sharedLocator].locationManager.location coordinate];
    
    // We want to center on the graticule, not the user, so we need to do some math.
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
    
    // Now grab the hash coords.
    CLLocationCoordinate2D hashCoords = [[DRHGeohashLocator sharedLocator] retrieveHashForLat: coords.latitude andLon: coords.longitude forDate: datePicker.dateValue];
    
    // Create an annotation.
    MKPointAnnotation * point = [[MKPointAnnotation alloc] init];
    point.coordinate = hashCoords;
    
    // And add it to the map.
    [mapView addAnnotation: point];
}

@end
