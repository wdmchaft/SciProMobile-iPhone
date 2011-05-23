//
//  StatusReportViewController.h
//  SciProMobile
//
//  Created by Johan Aschan on 2011-05-08.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StatusReportViewController : UIViewController {
    
    UITextField *statusMessageTextField;
    UISwitch *availableSwitch;
    NSMutableData *responseData;
    UIActivityIndicatorView *activityIndicator;
}
@property (nonatomic, retain) IBOutlet UISwitch *availableSwitch;
@property (nonatomic, retain) IBOutlet UITextField *statusMessageTextField;
- (IBAction)updateStatus:(id)sender;
- (void) setStatus;
- (void)updateView;
@end
