//
//  CampinViewController.m
//  Campwhere
//
//  Created by Dan Shriver on 8/5/14.
//  Copyright (c) 2014 Dan Shriver. All rights reserved.
//

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

#import "CampinViewController.h"
#import "CampinSearchBoxView.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreData/CoreData.h>
#import "CampinAppDelegate.h"

@interface CampinViewController ()


@property (weak, nonatomic) IBOutlet UIView *iPadMapView;
@property (weak, nonatomic) IBOutlet UIButton *iPadShowBtn;

@property (nonatomic, strong) CampinSearchBoxView *iPadBox;

@end

@implementation CampinViewController
{
    GMSMapView *mapView_;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:41.559991
                                                            longitude:-93.5996495
                                                                 zoom:6];
    
    if (IDIOM == IPAD) {
        
        
        mapView_ = [GMSMapView mapWithFrame:self.iPadMapView.frame camera:camera];
    }
    else
    {
        // use iphone map view
    }
    
    mapView_.myLocationEnabled = YES;
    [self.view insertSubview:mapView_ belowSubview:self.iPadShowBtn];
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(41.559991, -93.5996495);
    marker.title = @"Des Moines";
    marker.snippet = @"Iowa";
    marker.map = mapView_;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark SearchBox delegate methods
- (void)showButton
{
    self.iPadShowBtn.hidden = NO;
}

- (void)startIpadSearchWithLocation:(CLLocationCoordinate2D)location radius:(int)searchRadius{
    
    CampinAppDelegate *appDel = (CampinAppDelegate*)[UIApplication sharedApplication].delegate;
    
    double meanLatitude = location.latitude * M_PI / 180;
    double deltaLatitude = searchRadius / EARTH_RADIUS * 180 / M_PI;
    double deltaLongitude = searchRadius / (EARTH_RADIUS * cos(meanLatitude)) * 180 / M_PI;
    double minLat = location.latitude - deltaLatitude;
    double maxLat = location.latitude + deltaLatitude;
    double minLong = location.longitude - deltaLongitude;
    double maxLong = location.longitude + deltaLongitude;
    
    NSFetchRequest *searchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Park" inManagedObjectContext:appDel.managedObjectContext];
    [searchRequest setEntity:entity];
    // //   NSNumber *radiusNum = [NSNumber numberWithInteger:searchRadius];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(%@ <= lng) AND (lng <= %@)"
                              @"AND (%@ <= lat) AND (lat <= %@)",
                              @(minLong), @(maxLong), @(minLat), @(maxLat)];
    [searchRequest setPredicate:predicate];
    searchRequest.returnsObjectsAsFaults = NO;
    
    NSError *fetchError = nil;
    NSArray *results = [appDel.managedObjectContext executeFetchRequest:searchRequest error:&fetchError];
    
    if (!fetchError) {
        // plot the parks found
        [self animateMapAndPlotParksWithResults:results location:location];
    }
}

- (void)animateMapAndPlotParksWithResults:(NSArray*)results location:(CLLocationCoordinate2D)searchLocation
{
    // remove existing markers
    [mapView_ clear];
    
    
    // animate map to location and bounds (zoom level)
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:searchLocation coordinate:searchLocation];
 //   [bounds includingCoordinate:searchLocation];
   // [GMSCameraUpdate fitBounds:bounds];
  //  [mapView_ moveCamera:[GMSCameraUpdate fitBounds:bounds]];
//    GMSCameraPosition *camera = [[GMSCameraPosition alloc] initWithTarget:searchLocation zoom:10 bearing:0 viewingAngle:0];
    
//    [mapView_ animateToCameraPosition:camera];
    
    NSNumber *latitude;
    NSNumber *longitude;
    NSString *name;
    
    for (NSManagedObject *managedObject in results) {
        NSLog(@"Name: %@, Type: %@", [managedObject valueForKey:@"name"], [managedObject valueForKey:@"type"]);
        latitude = [managedObject valueForKey:@"lat"];
        longitude = [managedObject valueForKey:@"lng"];
        name = [managedObject valueForKey:@"name"];
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        CLLocationCoordinate2D thisPosition = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
        
        marker.position = thisPosition;
        marker.snippet = name;
        marker.appearAnimation = kGMSMarkerAnimationNone;
        marker.map = mapView_;
        
        bounds = [bounds includingCoordinate:thisPosition];
    }
    
    [mapView_ animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:30.0f]];
}

- (IBAction)showIPadBox:(id)sender
{
    self.iPadShowBtn.hidden = YES;
    CGFloat xPos = [UIScreen mainScreen].bounds.size.width - 70.0f;
    self.iPadBox = [[CampinSearchBoxView new] initWithFrame:CGRectMake(xPos, 32, 50, 50)];
    self.iPadBox.alpha = 0.0f;
    self.iPadBox.delegate = self;
    [self.view insertSubview:self.iPadBox aboveSubview:mapView_];
    
    // maybe add a bounce effect here
    [UIView animateWithDuration:0.3f animations:^{
        
        CGRect newFrame = CGRectMake(20, 32, 700, 140);
        self.iPadBox.frame = newFrame;
        self.iPadBox.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
        
    }];
}

@end
