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
