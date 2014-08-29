//
//  CampinIphoneSearchBox.h
//  Campwhere
//
//  Created by Dan Shriver on 8/28/14.
//  Copyright (c) 2014 Dan Shriver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol IphoneSearchBoxDelegate <NSObject>

- (void)showButton;
- (void)startIphoneSearchWithLocation:(CLLocationCoordinate2D)location radius:(int)searchRadius;

@end

@interface CampinIphoneSearchBox : UIView

@property (nonatomic, assign) id<IphoneSearchBoxDelegate> delegate;

@end
