//
//  ProjectViewController.h
//  SciProMobile
//
//  Created by Johan Aschan on 2011-04-07.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>



@interface ProjectViewController : UITableViewController <CLLocationManagerDelegate> {
    
    NSMutableData *responseData;
    NSMutableArray *projects; 
    CLLocationManager *locationManager;
    CLLocation *bestEffortAtLocation;
    
}
- (IBAction)projectButton:(id)sender;
- (BOOL)registerRegionWithIdentifier:(NSString*)identifier;
- (void)updateView;
- (void)getUnreadMessageNumber;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *bestEffortAtLocation;

@end
