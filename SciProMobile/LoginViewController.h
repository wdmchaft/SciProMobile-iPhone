//
//  LoginViewController.h
//  SciProMobile
//
//  Created by Johan Aschan on 2011-04-07.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LoginViewController;

@protocol LoginViewControllerDelegate
-(void)loginViewControllerDidFinish:(LoginViewController *)loginViewController;
@end

@interface LoginViewController : UIViewController<UITextFieldDelegate> {
    id <LoginViewControllerDelegate> delegate;
    UITextField *usernameTextField;
    UITextField *passwordTextField;
    UILabel *label;
    NSMutableData *responseData;
}

@property (nonatomic, assign) id <LoginViewControllerDelegate> delegate;

@property (nonatomic, retain) IBOutlet UITextField *usernameTextField;

@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;
@property (nonatomic, retain) IBOutlet UILabel *label;

- (IBAction)buttonPressed:(id)sender;

@end




