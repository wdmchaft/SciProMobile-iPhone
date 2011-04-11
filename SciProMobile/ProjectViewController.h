//
//  ProjectViewController.h
//  SciProMobile
//
//  Created by Johan Aschan on 2011-04-07.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ProjectViewController : UIViewController {
    
    UITableView *projectTable;
    NSMutableData *responseData;
}
- (IBAction)projectButton:(id)sender;


@end
