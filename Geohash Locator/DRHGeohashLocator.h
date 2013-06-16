//
//  DRHGeohashLocator.h
//  Geohash Locator
//
//  Created by Drew R. Hood on 6/15/13.
//  Copyright (c) 2013 Drew R. Hood. All rights reserved.
//

#import <Foundation/Foundation.h>

// Constants
extern NSString * const kLocationManagerDidStartTrackingNotification;
extern NSString * const kLocationManagerDidStopTrackingNotification;
extern NSString * const kLocationManagerDidUpdateLocationNotification;

@interface DRHGeohashLocator : NSObject <CLLocationManagerDelegate>
{
    CLLocationManager * locationManager;
    
    BOOL tracking;
}

/* Properties *\
\**************/

@property (nonatomic, retain) CLLocationManager * locationManager;
@property (nonatomic) BOOL tracking;

/* Methods *\
\***********/

// Instance Management
+(DRHGeohashLocator *) sharedLocator;
-(DRHGeohashLocator *) init;

// Geohashing
-(CLLocationCoordinate2D) retrieveHashForLat: (CLLocationDegrees) lat andLon: (CLLocationDegrees) lon forDate: (NSDate *) date;

// Tracking Setup
-(CLLocationManager *) startTracking;
-(void) stopTracking;

/* Location Manager Delegation *\
\*******************************/

-(void) locationManager: (CLLocationManager *) manager didChangeAuthorizationStatus: (CLAuthorizationStatus) status;
-(void) locationManager: (CLLocationManager *) manager didFailWithError: (NSError *) error;
-(void) locationManager: (CLLocationManager *) manager didUpdateToLocation: (CLLocation *) newLoc fromLocation: (CLLocation *) oldLoc;


@end
