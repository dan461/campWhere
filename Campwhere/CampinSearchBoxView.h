//
//  CampinSearchBoxView.h
//  Campwhere
//
//  Created by Dan Shriver on 8/6/14.
//  Copyright (c) 2014 Dan Shriver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@protocol SearchBoxDelegate <NSObject>

- (void)showButton;
- (void)startIpadSearchWithLocation:(CLLocationCoordinate2D)location radius:(int)searchRadius;


@end

@interface CampinSearchBoxView : UIView <UITextFieldDelegate>

@property (nonatomic, assign) id<SearchBoxDelegate> delegate;

@end
