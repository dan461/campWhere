//
//  CampinViewController.h
//  Campwhere
//
//  Created by Dan Shriver on 8/5/14.
//  Copyright (c) 2014 Dan Shriver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CampinSearchBoxView.h"
#import "CampinIphoneSearchBox.h"

static const double EARTH_RADIUS = 3960; // MILES

@interface CampinViewController : UIViewController <SearchBoxDelegate, IphoneSearchBoxDelegate>

- (void)showButton;
- (void)startIpadSearchWithLocation:(CLLocationCoordinate2D)location radius:(int)searchRadius;
-(void)startIphoneSearchWithLocation:(CLLocationCoordinate2D)location radius:(int)searchRadius;

@end
