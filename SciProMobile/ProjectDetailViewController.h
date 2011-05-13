//
//  ProjectDetailViewController.h
//  SciProMobile
//
//  Created by Johan Aschan on 2011-04-07.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProjectDetailViewController : UIViewController {
    NSMutableData *responseData;
    UILabel *projectTitle;
    UILabel *members;
    UILabel *level;
    UIImageView *statusImage;
    UILabel *reviewer;
    UILabel *coSupervisors;
    UILabel *statusMessage;
}
@property (nonatomic, retain) IBOutlet UILabel *statusMessage;
@property (nonatomic, retain) IBOutlet UILabel *projectTitle;
@property (nonatomic, retain) IBOutlet UILabel *members;
@property (nonatomic, retain) IBOutlet UILabel *level;
@property (nonatomic, retain) IBOutlet UIImageView *statusImage;
@property (nonatomic, retain) IBOutlet UILabel *reviewer;
@property (nonatomic, retain) IBOutlet UILabel *coSupervisors;
- (IBAction)messageToProject:(id)sender;

@end
