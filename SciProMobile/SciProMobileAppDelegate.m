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
#import "StatusReportViewController.h"
#import <CoreLocation/CoreLocation.h>

@implementation SciProMobileAppDelegate


@synthesize window=_window;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    tabBarController = [[UITabBarController alloc] init];
    projectNavController = [[UINavigationController alloc]init];
    messageNavController = [[UINavigationController alloc]init];
    UINavigationController *statusNavController = [[UINavigationController alloc]init];
    projectViewController = [[ProjectViewController alloc] init];
    messageViewController = [[MessageViewController alloc] init];
    StatusReportViewController *statusReportViewController = [[StatusReportViewController alloc] init];
    statusReportViewController.title = @"Status";
    projectViewController.title = @"Project";
    messageViewController.title = @"Message";
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled. If you proceed, you will be asked to confirm whether location services should be reenabled." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [servicesDisabledAlert show];
        [servicesDisabledAlert release];
    }




    [messageNavController pushViewController:messageViewController animated:NO];
    [projectNavController pushViewController:projectViewController animated:NO];
    [statusNavController pushViewController:statusReportViewController animated:NO];
    [projectViewController release];
    [messageViewController release];
    [statusReportViewController release];
    
    tabBarController.viewControllers = [NSArray arrayWithObjects:projectNavController, messageNavController, statusNavController, nil];
    UIImage* anImage = [UIImage imageNamed:@"18-envelope.png"];
    UITabBarItem* theItem = [[UITabBarItem alloc] initWithTitle:@"Message" image:anImage tag:0];
    messageNavController.tabBarItem = theItem;
    [theItem release];
    
    anImage = [UIImage imageNamed:@"33-cabinet.png"];
    theItem = [[UITabBarItem alloc] initWithTitle:@"Project" image:anImage tag:0];
    projectNavController.tabBarItem = theItem;
    [theItem release];
    
    anImage = [UIImage imageNamed:@"74-location.png"];
    theItem = [[UITabBarItem alloc] initWithTitle:@"Status" image:anImage tag:0];
    statusNavController.tabBarItem = theItem;
    [theItem release];
   
    [projectNavController release];
    [messageNavController release];
    [statusNavController release];
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
    [tabBarController release];
    [_window release];
    [super dealloc];
}

@end
