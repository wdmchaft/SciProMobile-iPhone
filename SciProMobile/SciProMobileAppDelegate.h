//
//  SciProMobileAppDelegate.h
//  SciProMobile
//
//  Created by Johan Aschan on 2011-03-30.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@class ProjectViewController;
@class MessageViewController;
@class SettingsViewController;

@interface SciProMobileAppDelegate : NSObject <UIApplicationDelegate, LoginViewControllerDelegate> {
    
    UINavigationController *navController;
    UITabBarController *tabBarController;
    ProjectViewController *projectViewController;
    MessageViewController *messageViewController;
    SettingsViewController *settingsViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;


@end
