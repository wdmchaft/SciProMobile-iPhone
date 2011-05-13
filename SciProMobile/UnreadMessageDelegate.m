
//
//  UnreadMessageDelegate.m
//  SciProMobile
//
//  Created by Johan Aschan on 2011-05-12.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import "UnreadMessageDelegate.h"
#import "JSON.h"
#import "LoginViewController.h"


@implementation UnreadMessageDelegate
@synthesize tabBarItem;


- (id)init{	
	if ((self = [super init])) {
        responseData = [[NSMutableData data] retain];
	}
	return self;
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[NSString stringWithFormat:@"Connection failed: %@", [error description]];
    [connection release];
    [responseData release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
    
	NSError *error;
	SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    
	NSMutableDictionary *projectDictionary = [jsonParser objectWithString:responseString error:&error];
    if (projectDictionary == nil)
		[NSString stringWithFormat:@"JSON parsing failed: %@", [error localizedDescription]];
	else {
        NSString *apiCheck = [projectDictionary objectForKey:@"apikey"];
        
        if ([apiCheck isEqualToString:@"success"]){
            if([[projectDictionary objectForKey:@"unreadmess"] isEqualToNumber: [NSNumber numberWithInt:0]])
                tabBarItem.badgeValue = nil;
            else
                tabBarItem.badgeValue = [[projectDictionary objectForKey:@"unreadmess"] stringValue];
            
        } else{
            UIAlertView *errorAlert = [[UIAlertView alloc]
                                       initWithTitle: @"Connection problems"
                                       message: @"API-key mismatched login again."
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
            [errorAlert show];
            [errorAlert release];
            LoginViewController *lvc = [[LoginViewController alloc] init];
            lvc.delegate = [[UIApplication sharedApplication] delegate];
            [[lvc tabBarController] presentModalViewController:lvc animated:NO];
            [lvc release];
            
        }
        
    }
    [responseString release];	
    [jsonParser release];
    
}

- (void)dealloc
{
    [tabBarItem release];
    [super dealloc];
}

@end
