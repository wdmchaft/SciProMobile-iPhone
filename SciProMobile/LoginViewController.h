//
//  LoginViewController.h
//  SciProMobile
//
//  Created by Johan Aschan on 2011-04-07.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Reachability;

@interface LoginViewController : UIViewController<UITextFieldDelegate> {
    id delegate;
    UITextField *usernameTextField;
    UITextField *passwordTextField;
    UILabel *label;
    NSMutableData *responseData;
    Reachability* internetReachable;
    Reachability* hostReachable;
    BOOL internetActive;
    BOOL hostActive;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) BOOL internetActive;
@property (nonatomic, assign) BOOL hostActive;

@property (nonatomic, retain) IBOutlet UITextField *usernameTextField;

@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;
@property (nonatomic, retain) IBOutlet UILabel *label;

- (IBAction)buttonPressed:(id)sender;
- (void)loginWithUserName:(NSString*) userName password:(NSString*) password;
- (void) checkNetworkStatus:(NSNotification *)notice;

@end
