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
#import "LoginSingleton.h"
#import "UnreadMessageDelegate.h"
#import "AvailableChecker.h"

@implementation SciProMobileAppDelegate


@synthesize window=_window, tabBarController, locationManager, available;


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *deviceTokenString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    [LoginSingleton instance].iphoneId = deviceTokenString;
    NSLog(@"%@", deviceTokenString);
    
} 

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	NSLog(@"Error in registration. Error: %@", error); 
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        NSLog(@"Recieved Notification %@",localNotif);
    }
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    
    tabBarController = [[UITabBarController alloc] init];
    projectNavController = [[UINavigationController alloc]init];
    messageNavController = [[UINavigationController alloc]init];
    UINavigationController *statusNavController = [[UINavigationController alloc]init];
    projectViewController = [[ProjectViewController alloc] init];
    messageViewController = [[MessageViewController alloc] init];
    StatusReportViewController *statusReportViewController = [[StatusReportViewController alloc] init];
    statusReportViewController.title = @"Status";
    projectViewController.title = @"Project";
    messageViewController.title = @"Inbox";
    
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
- (void)setupLocation{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    done = NO;
    if ( [CLLocationManager locationServicesEnabled]){
        
        if([defaults boolForKey:@"location"]){
            [locationManager startUpdatingLocation];
        }else{
            [locationManager stopUpdatingLocation];
        }
    }
    
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if([LoginSingleton instance].user != nil){
        [messageViewController updateView];
    }
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

- (void)applicationDidBecomeActive:(UIApplication *)application{
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;  
    if([LoginSingleton instance].user != nil){
        AvailableChecker *availableChecker = [[AvailableChecker alloc]init];
        [availableChecker available];
        [availableChecker release];
    } else{
        projectViewController.availCheck = YES;
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)locationManager: (CLLocationManager *)manager
       didFailWithError: (NSError *)error
{
    [manager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    CLLocation* vbg = [[CLLocation alloc] initWithLatitude:59.40536 longitude:17.94448];
    
    CLLocationDistance distance = [newLocation distanceFromLocation:vbg]; 
    if([manager desiredAccuracy] == kCLLocationAccuracyBest){
        if(distance <= 200 && !available && !done){ 
            if(!atDSV){
                UIAlertView *errorAlert = [[UIAlertView alloc]
                                           initWithTitle: @"At DSV"
                                           message: @"At DSV update your status"
                                           delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
                [errorAlert show];
                [errorAlert release];
                done = YES;
                atDSV = YES;
                notAtDSV = NO;
            }
        } else if(distance > 200 && available && !done){
            
            if(!notAtDSV){
                UIAlertView *errorAlert = [[UIAlertView alloc]
                                           initWithTitle: @"Not at DSV"
                                           message: @"Not at DSV update your status"
                                           delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
                [errorAlert show];
                [errorAlert release];
                done = YES;
                notAtDSV = YES;
                atDSV = NO;
            }
        }
        [locationManager stopUpdatingLocation];
    }
    [vbg release];
    // else skip the event and process the next one.
}

- (void)dealloc
{
    [locationManager release];
    [tabBarController release];
    [_window release];
    [super dealloc];
}

@end
