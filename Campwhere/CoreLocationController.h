//
//  CoreLocationController.h
//  Camp2
//
//  Created by Dan Shriver on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

//@protocol CoreLocationControllerDelegate
//@required
//
//-(void)locationUpdate:(CLLocation *)location; //location updates sent here
//-(void)locationError:(NSError *)error;
//
//@end

@interface CoreLocationController : NSObject <CLLocationManagerDelegate>

+ (id)sharedManager;

@property (nonatomic, strong) CLLocationManager *locManager;
@property (nonatomic, strong) CLLocation *currentLocation;
//@property (nonatomic, retain) id <CoreLocationControllerDelegate> delegate;



@end
