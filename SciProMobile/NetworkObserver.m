//
//  NetworkObserver.m
//  SciPro
//
//  Created by idlab1 on 2011-07-04.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import "NetworkObserver.h"
#import "Reachability.h"

@implementation NetworkObserver

@synthesize internetActive, hostActive;


- (id)init{	
	if ((self = [super init])) {
        internetReachable = [[Reachability reachabilityForInternetConnection] retain];
        [internetReachable startNotifier];
        
        // check if a pathway to a random host exists
        hostReachable = [[Reachability reachabilityWithHostName: @"thesis.dsv.su.se"] retain];
        [hostReachable startNotifier];
	}
	return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void) checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    

    
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    
    {
        case NotReachable:
        {
            self.internetActive = NO;
            UIAlertView *errorAlert = [[UIAlertView alloc]
                                       initWithTitle: @"Connection problems"
                                       message: @"Internet down."
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
            [errorAlert show];
            [errorAlert release];
            break;
            
        }
        case ReachableViaWiFi:
        {
            self.internetActive = YES;
            break;
        }
        case ReachableViaWWAN:
        {
            self.internetActive = YES;
            break;
            
        }
    }
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    
    {
        case NotReachable:
        {
            self.hostActive = NO;
            UIAlertView *errorAlert = [[UIAlertView alloc]
                                       initWithTitle: @"Connection problems"
                                       message: @"No connection to the host."
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
            [errorAlert show];
            [errorAlert release];
            
            break;
            
        }
        case ReachableViaWiFi:
        {
            self.hostActive = YES;
            
            break;
            
        }
        case ReachableViaWWAN:
        {
            self.hostActive = YES;
            break;
            
        }
    }
}

@end
