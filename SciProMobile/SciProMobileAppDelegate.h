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

@interface SciProMobileAppDelegate : NSObject <UIApplicationDelegate, LoginViewControllerDelegate> {
    
    UINavigationController *projectNavController;
    UINavigationController *messageNavController;
    UITabBarController *tabBarController;
    ProjectViewController *projectViewController;
    MessageViewController *messageViewController;
    NSMutableData *responseData;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;


@end
