//
//  SciProMobileViewController.h
//  SciProMobile
//
//  Created by Johan Aschan on 2011-03-30.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SciProMobileViewController : UIViewController<UITextFieldDelegate>  {
    
    UITextField *textField;
    UILabel *label;
    NSString *userName;
}



@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) IBOutlet UILabel *label;

@property (nonatomic, copy) NSString *userName;
- (IBAction)changeGreeting:(id)sender;

@end
