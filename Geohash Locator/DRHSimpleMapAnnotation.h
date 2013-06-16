//
//  DRHSimpleMapAnnotation.h
//  Geohash Locator
//
//  Created by Drew R. Hood on 6/15/13.
//  Copyright (c) 2013 Drew R. Hood. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRHSimpleMapAnnotation : NSObject <MKAnnotation>
{
    // Model
    CLLocationCoordinate2D coordinate;
}

/* Properties *\
\**************/

@property (nonatomic) CLLocationCoordinate2D coordinate;

/* Methods *\
\***********/

// Init
-(id) initWithCoordinate: (CLLocationCoordinate2D) coord;

// Information
-(NSString *) title;
-(NSString *) subtitle;

@end
