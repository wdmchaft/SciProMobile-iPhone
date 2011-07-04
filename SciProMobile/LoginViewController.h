//
//  LoginViewController.h
//  SciProMobile
//
/*
 * Copyright (c) 2011 Johan Aschan.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <UIKit/UIKit.h>
#import "NetworkObserver.h"

@class Reachability;

@interface LoginViewController : UIViewController<UITextFieldDelegate> {
    id delegate;
    UITextField *usernameTextField;
    UITextField *passwordTextField;
    UILabel *label;
    NSMutableData *responseData;
    NetworkObserver *networkObserver;

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

@end
