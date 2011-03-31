//
//  SciProMobileViewController.h
//  SciProMobile
//
//  Created by Johan Aschan on 2011-03-30.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SciProMobileViewController : UIViewController {
    
    UITextField *textField;
    UITextField *label;
}

- (IBAction)changeGreeting:(id)sender;

@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) IBOutlet UITextField *label;

@end
