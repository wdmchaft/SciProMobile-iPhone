//
//  SciProMobileAppDelegate.m
//  SciProMobile
//
//  Created by Johan Aschan on 2011-03-30.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import "SciProMobileAppDelegate.h"

#import "ProjectViewController.h"
#import "MessageViewController.h"
#import "SettingsViewController.h"


@implementation SciProMobileAppDelegate


@synthesize window=_window;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    tabBarController = [[UITabBarController alloc] init];
    navController = [[UINavigationController alloc]init];
    projectViewController = [[ProjectViewController alloc] init];
    messageViewController = [[MessageViewController alloc] init];
    settingsViewController = [[SettingsViewController alloc] init];
    

    
    
    tabBarController.viewControllers = [NSArray arrayWithObjects:navController, projectViewController, messageViewController, settingsViewController, nil];
   
    [_window addSubview:tabBarController.view];
    [self.window makeKeyAndVisible];
    LoginViewController *lvc = [[LoginViewController alloc] init];
    lvc.delegate = self;
    [tabBarController presentModalViewController:lvc animated:NO];
    [lvc release];

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

-(void)loginViewControllerDidFinish:(LoginViewController*)loginViewController {
    [tabBarController dismissModalViewControllerAnimated:NO];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [projectViewController release];
    [settingsViewController release];
    [messageViewController release];
    [tabBarController release];
    [navController release];
    [_window release];
    [super dealloc];
}

@end
