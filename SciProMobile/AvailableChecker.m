//
//  AvailableChecker.m
//  SciPro
//
//  Created by Johan Aschan on 2011-05-23.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import "AvailableChecker.h"
#import "LoginViewController.h"
#import "LoginSingleton.h"
#import "SciProMobileAppDelegate.h"
#import "JSON.h"


@implementation AvailableChecker

- (void)available{
    responseData = [[NSMutableData data] retain];
    NSMutableString *url = [NSMutableString stringWithString:@"http://130.229.141.110:8080 json/status?userid="];
    [url appendString:[[LoginSingleton instance].user.userId stringValue]];
	[url appendString:@"&apikey="];
    [url appendString:[LoginSingleton instance].apikey];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLConnection *conn= [[NSURLConnection alloc] initWithRequest:request delegate:self];  
    if (!conn){
        
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle: @"Connection problems"
                                   message: @"Connection problems, try login again."
                                   delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
        [LoginSingleton instance].user = nil;
        [LoginSingleton instance].iphoneId = nil;
        [LoginSingleton instance].apikey = nil;
        LoginViewController *lvc = [[LoginViewController alloc] init];
        lvc.delegate = [[UIApplication sharedApplication] delegate];
        SciProMobileAppDelegate *sciProMobileAppDelegate = [[UIApplication sharedApplication] delegate];
        [sciProMobileAppDelegate.tabBarController presentModalViewController:lvc animated:NO];
        [lvc release];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
    [connection release];
    [responseData release];
    responseData = nil;
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle: @"Connection problems"
                               message: @"Connections problems, try login again."
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
    [errorAlert show];
    [errorAlert release];
    [LoginSingleton instance].user = nil;
    [LoginSingleton instance].iphoneId = nil;
    [LoginSingleton instance].apikey = nil;
    LoginViewController *lvc = [[LoginViewController alloc] init];
    lvc.delegate = [[UIApplication sharedApplication] delegate];
    SciProMobileAppDelegate *sciProMobileAppDelegate = [[UIApplication sharedApplication] delegate];
    [sciProMobileAppDelegate.tabBarController presentModalViewController:lvc animated:NO];
    [lvc release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
    responseData = nil;
	NSError *error;
	SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    
	NSMutableDictionary *projectDictionary = [jsonParser objectWithString:responseString error:&error];
    if (projectDictionary == nil){
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle: @"Connection problems"
                                   message: @"Connections problems, try login again."
                                   delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
        [LoginSingleton instance].user = nil;
        [LoginSingleton instance].iphoneId = nil;
        [LoginSingleton instance].apikey = nil;
        LoginViewController *lvc = [[LoginViewController alloc] init];
        lvc.delegate = [[UIApplication sharedApplication] delegate];
        SciProMobileAppDelegate *sciProMobileAppDelegate = [[UIApplication sharedApplication] delegate];
        [sciProMobileAppDelegate.tabBarController presentModalViewController:lvc animated:NO];
        [lvc release];
	} else {
        NSString *apiCheck = [projectDictionary objectForKey:@"apikey"];
        
        if ([apiCheck isEqualToString:@"success"]){
            SciProMobileAppDelegate *sciproMobileAppDelegate = [[UIApplication sharedApplication] delegate];
            
            if([[projectDictionary objectForKey:@"status"] isEqualToNumber: [NSNumber numberWithInt:0]])
                sciproMobileAppDelegate.available = NO;
            else
                sciproMobileAppDelegate.available = YES;
            [sciproMobileAppDelegate setupLocation];
            
        } else{
            UIAlertView *errorAlert = [[UIAlertView alloc]
                                       initWithTitle: @"Connection problems"
                                       message: @"Connections problems, try login again."
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
            [errorAlert show];
            [errorAlert release];
            LoginViewController *lvc = [[LoginViewController alloc] init];
            lvc.delegate = [[UIApplication sharedApplication] delegate];
            SciProMobileAppDelegate *sciProMobileAppDelegate = [[UIApplication sharedApplication] delegate];
            [sciProMobileAppDelegate.tabBarController presentModalViewController:lvc animated:NO];
            [lvc release];
            
        }
        
    }
    [responseString release];	
    [jsonParser release];
}

@end
