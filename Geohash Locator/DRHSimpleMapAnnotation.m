//
//  DRHSimpleMapAnnotation.m
//  Geohash Locator
//
//  Created by Drew R. Hood on 6/15/13.
//  Copyright (c) 2013 Drew R. Hood. All rights reserved.
//

#import "DRHSimpleMapAnnotation.h"

@implementation DRHSimpleMapAnnotation

/* Properties *\
\**************/

@synthesize coordinate;

/* Methods *\
\***********/

// Init
-(id) initWithCoordinate: (CLLocationCoordinate2D) coord
{
    self = [super init];
    
    coordinate = coord;
    
    return self;
}

// Information
-(NSString *) title
{
    return nil;
}

-(NSString *) subtitle
{
    return nil;
}

@end
