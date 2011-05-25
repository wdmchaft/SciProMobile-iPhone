//
//  ProjectViewController.h
//  SciProMobile
//
//  Created by Johan Aschan on 2011-04-07.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface ProjectViewController : UITableViewController  {
    
    NSMutableData *responseData;
    NSMutableArray *projects; 
    UIActivityIndicatorView *activityIndicator;
    BOOL availCheck;
    
}
@property (nonatomic, assign) BOOL availCheck;
- (IBAction)projectButton:(id)sender;
- (BOOL)registerRegionWithIdentifier:(NSString*)identifier;
- (void)updateView;
- (void)getUnreadMessageNumber;


@end
