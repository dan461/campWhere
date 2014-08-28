//
//  CampinSearchBoxView.m
//  Campwhere
//
//  Created by Dan Shriver on 8/6/14.
//  Copyright (c) 2014 Dan Shriver. All rights reserved.
//

#import "CampinSearchBoxView.h"
#import "CoreLocationController.h"

@interface CampinSearchBoxView()

@property (weak, nonatomic) IBOutlet UISlider *iPadRadiusSlider;
@property (weak, nonatomic) IBOutlet UILabel *iPadRadiusLabel;

@property (weak, nonatomic) IBOutlet UIButton *HideShowBtn;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIButton *cityStateBtn;
@property (weak, nonatomic) IBOutlet UIButton *latLongBtn;
@property (weak, nonatomic) IBOutlet UIButton *myLocBtn;

@property (weak, nonatomic) IBOutlet UITextField *cityStateField;
@property (weak, nonatomic) IBOutlet UITextField *latField;
@property (weak, nonatomic) IBOutlet UITextField *longField;

@property (nonatomic, strong) NSNumber *radiusNum;

@end

@implementation CampinSearchBoxView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    CampinSearchBoxView *boxView = [[[NSBundle mainBundle] loadNibNamed:@"CampinSearchBoxView" owner:nil options:nil] lastObject];
    boxView.frame = frame;
    if (self) {
        [self layoutIfNeeded];
    }
    return boxView;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.cityStateField.hidden = NO;
    self.latField.hidden = YES;
    self.longField.hidden = YES;
    
  //  [self.cityStateBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [self.cityStateBtn setSelected:YES];
}

- (IBAction)cityStatePicked:(id)sender
{
    if (![self.cityStateBtn isSelected]) {
        [self.cityStateBtn setSelected:YES];
        [self.latLongBtn setSelected:NO];
        [self.myLocBtn setSelected:NO];
        
        self.cityStateField.hidden = NO;
        self.latField.hidden = YES;
        self.longField.hidden = YES;
    }
    
}

- (IBAction)latLongPicked:(id)sender
{
    if (![self.latLongBtn isSelected]) {
        [self.cityStateBtn setSelected:NO];
        [self.latLongBtn setSelected:YES];
        [self.myLocBtn setSelected:NO];
        
        self.cityStateField.hidden = YES;
        self.latField.hidden = NO;
        self.longField.hidden = NO;
    }
}

// show user's current lat/long
- (IBAction)myLocPicked:(id)sender
{
    if (![self.myLocBtn isSelected]) {
        [self.cityStateBtn setSelected:NO];
        [self.latLongBtn setSelected:NO];
        [self.myLocBtn setSelected:YES];
        
        self.cityStateField.hidden = YES;
        self.latField.hidden = NO;
        self.longField.hidden = NO;
        
        // get user's location, convert lat/long to strings
        if ([CLLocationManager locationServicesEnabled]) {
            [[[CoreLocationController sharedManager] locManager] startUpdatingLocation];
            CLLocation *here = [[CoreLocationController sharedManager] currentLocation];
            NSString *latString = [NSString stringWithFormat:@"%f", here.coordinate.latitude];
            NSString *longString = [NSString stringWithFormat:@"%f", here.coordinate.longitude];
            [self.latField setText:latString];
            [self.longField setText:longString];
        }
    }
}

- (IBAction)startSearch:(id)sender
{
    
    if ([self.cityStateBtn isSelected]) {
        // get lat/long if needed
        
        NSString *cityState = self.cityStateField.text;
        CLLocation __block *thisLocation;
        
        CLGeocoder *geoCoder = [CLGeocoder new];
        [geoCoder geocodeAddressString:cityState completionHandler:^(NSArray *placemarks, NSError *error) {
            if (!error) {
                
                CLPlacemark *placemark = [placemarks firstObject];
                thisLocation = placemark.location;
                
                if (thisLocation) {
                    double lat = thisLocation.coordinate.latitude;
                    double lng = thisLocation.coordinate.longitude;
                    int radius = [self.iPadRadiusLabel.text integerValue];
                    if ([self.delegate respondsToSelector:@selector(startIpadSearchWithLocation:radius:)]) {
                        
                        CLLocationCoordinate2D thisPosition = CLLocationCoordinate2DMake(lat, lng);
                        [self.delegate startIpadSearchWithLocation:thisPosition radius:radius];
                    }
                }
            }
            else
            {
                
            }
        }];
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(startIpadSearchWithLocation:radius:)]) {
            
            int radius = [self.iPadRadiusLabel.text integerValue];
            double lat = [self.latField.text doubleValue];
            double lng = [self.longField.text doubleValue];
            
            CLLocationCoordinate2D thisPosition = CLLocationCoordinate2DMake(lat, lng);
            [self.delegate startIpadSearchWithLocation:thisPosition radius:radius];
          
        }
    }
}

- (IBAction)hideBox:(id)sender
{
    [UIView animateWithDuration:0.1 animations:^{
        
        self.alpha = 0.3f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            
            self.alpha = 0.0f;
            CGFloat xPos = [UIScreen mainScreen].bounds.size.width - 70.0f;
            CGRect newFrame = CGRectMake(xPos, 32, 20, 20);
            self.frame = newFrame;
        } completion:^(BOOL finished) {
            if ([self.delegate respondsToSelector:@selector(showButton)]) {
                [self.delegate showButton];
            }
            
            [self removeFromSuperview];
        }];
    }];
}

- (IBAction)updateRadius:(UISlider *)sender
{
    int radiusValue = roundl([sender value]) * 25;
    self.radiusNum = [NSNumber numberWithInt:radiusValue];
    NSString *radString = [NSString stringWithFormat:@"%u miles", radiusValue];
    self.iPadRadiusLabel.text = radString;
 
}

//- (CLLocation*)findCityStateLatLong
//{
////    
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
