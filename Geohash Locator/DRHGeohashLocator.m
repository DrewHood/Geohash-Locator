//
//  DRHGeohashLocator.m
//  Geohash Locator
//
//  Created by Drew R. Hood on 6/15/13.
//  Copyright (c) 2013 Drew R. Hood. All rights reserved.
//

#import "DRHGeohashLocator.h"

// Globals
static DRHGeohashLocator * kSharedLocator;

// Constants
NSString * const kLocationManagerDidStartTrackingNotification = @"_kLocationManagerDidStartTrackingNotification";
NSString * const kLocationManagerDidStopTrackingNotification = @"_kLocationManagerDidStopTrackingNotification";
NSString * const kLocationManagerDidUpdateLocationNotification = @"_kLocationManagerDidUpdateLocationNotification";

@implementation DRHGeohashLocator

/* Properties *\
\**************/

@synthesize locationManager;
@synthesize tracking;

/* Methods *\
\***********/

// Instance Management
+(DRHGeohashLocator *) sharedLocator
{
    if ( !kSharedLocator ) {
        
        return [[DRHGeohashLocator alloc] init];
        
    }
    
    return kSharedLocator;
}

-(DRHGeohashLocator *) init
{
    self = [super init];
    
    kSharedLocator = self;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.purpose = @"I don't need a reason.";
    
    return self;
}

// Geohashing
-(CLLocationCoordinate2D) retrieveHashForLat: (CLLocationDegrees) lat andLon: (CLLocationDegrees) lon forDate: (NSDate *) date
{
    // Digest the data.
    lat = (int) lat;
    lon = (int) lon;
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    NSString * dateString = [dateFormatter stringFromDate: date];
    
    // Set up the URL for the API call.
    NSString * urlString = [NSString stringWithFormat: @"http://relet.net/geo/%i/%i/%@", (int) lat, (int) lon, dateString];
    
    NSLog(@"Calling relet... %@", urlString);
    
    NSURL * url = [NSURL URLWithString: urlString];
    
    // Call the API and buffer the data.
    NSData * resultData = [NSData dataWithContentsOfURL: url];
    
    // Parse the JSON into a dictionary.
    NSError * parsingError;
    
    NSDictionary * result = [NSJSONSerialization JSONObjectWithData: resultData options: NSJSONReadingMutableContainers error: &parsingError];
    
    // Prepare a container for the result.
    CLLocationCoordinate2D hashCoords;
    hashCoords.latitude = -1000;
    hashCoords.longitude = -1000;
    
    // Extract and parse results.
    if ( [result objectForKey: @"error"] == nil ) {
        
        // Extract the lat and lon.
        hashCoords.latitude = [[result valueForKey: @"lat"] doubleValue];
        hashCoords.longitude = [[result valueForKey: @"lon"] doubleValue];
        
    }
    
    NSLog(@"Hash point found: %f, %f", hashCoords.latitude, hashCoords.longitude);
    
    return hashCoords;
}

// Tracking Setup
-(CLLocationManager *) startTracking
{
    BOOL doIt = [CLLocationManager locationServicesEnabled];
    
    if ( doIt ) {
        
        switch ( [CLLocationManager authorizationStatus] ) {
            case kCLAuthorizationStatusNotDetermined:
                // Wait for auth.
                doIt = NO;
                break;
            case kCLAuthorizationStatusAuthorized:
                doIt = YES;
                break;
            default:
                doIt = NO;
                break;
        }
        
    }
    
    if ( doIt ) {
        
        // Start tracking.
        [locationManager startUpdatingLocation];
        tracking = YES;
        
        // Notify.
        [[NSNotificationCenter defaultCenter] postNotificationName: kLocationManagerDidStartTrackingNotification object: self];
        
    }

    return locationManager;
}

-(void) stopTracking
{
    if ( !tracking )
        return;
    
    [locationManager stopUpdatingLocation];
    tracking = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName: kLocationManagerDidStopTrackingNotification object: self];
}

/* Location Manager Delegation *\
\*******************************/

-(void) locationManager: (CLLocationManager *) manager didChangeAuthorizationStatus: (CLAuthorizationStatus) status
{
    if ( status == kCLAuthorizationStatusAuthorized )
        [self startTracking];
    else
        [self stopTracking];
}

-(void) locationManager: (CLLocationManager *) manager didFailWithError: (NSError *) error
{
    [self stopTracking];
    
    NSLog(@"Tracking failed: %@", [error description]);
}

-(void) locationManager: (CLLocationManager *) manager didUpdateToLocation: (CLLocation *) newLoc fromLocation: (CLLocation *) oldLoc
{
    NSLog(@"Location update: %@", [locationManager.location description]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName: kLocationManagerDidUpdateLocationNotification object: self];
}


@end
