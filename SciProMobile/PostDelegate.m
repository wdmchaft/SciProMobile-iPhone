//
//  SetReadDelegate.m
//  SciProMobile
//
//  Created by Johan Aschan on 2011-05-16.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import "PostDelegate.h"
#import "LoginSingleton.h"
#import "LoginViewController.h"
#import "JSON.h"
#import "SciProMobileAppDelegate.h"
#import "MessageViewController.h"

@implementation PostDelegate
@synthesize successAlert, successMessage, successTitle, messageViewController, message;

- (id)init{	
	if ((self = [super init])) {
        responseData = [[NSMutableData data] retain];
        successAlert = NO;
	}
	return self;
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	if(responseData != nil)
     [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [connection release];
    [responseData release];
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
    //
    NSError* error;
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    
	NSMutableDictionary *messDict = [jsonParser objectWithString:responseString error:&error];
    if (messDict == nil){
        
        NSLog(@"%@", [NSString stringWithFormat:@"JSON parsing failed: %@", [error localizedDescription]]);
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle: @"Connection problems"
                                   message: @"Connection problems."
                                   delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
	}else {
        NSString *apiCheck = [messDict objectForKey:@"apikey"];
        if (![apiCheck isEqualToString:@"success"]) {
            
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
        }else if(successAlert){
            
            UIAlertView *errorAlert = [[UIAlertView alloc]
                                       initWithTitle: successTitle
                                       message: successMessage
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
            [errorAlert show];
            [errorAlert release];
        }
        if([apiCheck isEqualToString:@"success"] && message){
            [messageViewController updateView];
        }
    }
    [responseString release];	
    [jsonParser release];   
}

- (void)dealloc
{   
    [successMessage release];
    [successTitle release];
    [super dealloc];
}
@end
