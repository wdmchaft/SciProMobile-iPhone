//
//  ProjectDetailViewController.h
//  SciProMobile
//
//  Created by Johan Aschan on 2011-04-07.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectModel.h"


@interface ProjectDetailViewController : UITableViewController {
    NSMutableData *responseData;
    ProjectModel *projectModel;
}

@property (nonatomic, retain) ProjectModel *projectModel;
- (IBAction)messageToProject:(id)sender;

@end
