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

@implementation SciProMobileAppDelegate


@synthesize window=_window, tabBarController, locationManager;


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
    self.locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [self setupLocation];


    
    
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
    
    self.locationManager.delegate = nil;
    [self.locationManager stopUpdatingLocation];
    return YES;
}
- (void)setupLocation{
    static NSString *identifier = @"DSV";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ( [CLLocationManager regionMonitoringAvailable] &&
        [CLLocationManager regionMonitoringEnabled] ){
        
        // If the radius is too large, registration fails automatically,
        // so clamp the radius to the max value.
        CLLocationDegrees radius = 100;
        
        if (radius > locationManager.maximumRegionMonitoringDistance)
            radius = locationManager.maximumRegionMonitoringDistance;
        
        CLLocationCoordinate2D coord;
        coord.latitude = 59.405334616707584;
        coord.longitude = 17.94440746307373;
        // Create the region and start monitoring it.
        CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:coord
                                                                   radius:radius identifier:identifier];
        if([defaults boolForKey:@"location"]){
            [locationManager startMonitoringForRegion:region
                                      desiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        }else{
            [locationManager stopMonitoringForRegion:region];
        }
        [region release];
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
    [self setupLocation];
    
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
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    if([region identifier] == @"DSV"){
        
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        if (localNotif == nil)
            return;
        
        localNotif.timeZone = [NSTimeZone defaultTimeZone];
        
        // Notification details
        localNotif.alertBody = @"Update your status so students can see if you are available.";
        // Set the action button
        
        localNotif.soundName = UILocalNotificationDefaultSoundName;
        
        // Specify custom data for the notification
        localNotif.fireDate = [NSDate date];
        // Schedule the notification
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        [localNotif release];
        
    }    
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{

    
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];

    
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    // Notification details
    localNotif.alertBody = @"Update your status so students can see if you are available.";
    // Set the action button
    
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    
    localNotif.fireDate = [NSDate date];
    // Schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    [localNotif release];
    
    
}

- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {
    // Handle the notificaton when the app is running
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state == UIApplicationStateActive) {
        //the app is in the foreground, so here you do your stuff since the OS does not do it for you
        //navigate the "aps" dictionary looking for "loc-args" and "loc-key", for example, or your personal payload)
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle: @"At DSV"
                                   message: notif.alertBody
                                   delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];;
    }
    }


- (void)dealloc
{
    [locationManager release];
    [tabBarController release];
    [_window release];
    [super dealloc];
}

@end
