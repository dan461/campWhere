//
//  CoreLocationController.m
//  Camp2
//
//  Created by Dan Shriver on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoreLocationController.h"

@implementation CoreLocationController

+ (id)sharedManager
{
    static CoreLocationController *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    
    self = [super init];
    
    if (self != nil) {
        self.locManager = [[CLLocationManager alloc] init];
        self.locManager.delegate = self;
        self.locManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.locManager.distanceFilter = 500;
        [self.locManager startUpdatingLocation];
        self.currentLocation = self.locManager.location;
//        self.locManager.delegate = self; // set the delegate as self
    }
    return self;
}

// checking that class assigning itself as delegate conforms to the protocol
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.currentLocation = newLocation;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
//    [self.delegate locationError:error];
    
}

@end
