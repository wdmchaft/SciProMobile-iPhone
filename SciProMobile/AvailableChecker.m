//
//  AvailableChecker.m
//  SciPro
//
/*.
 * Copyright (c) 2011 Johan Aschan.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "AvailableChecker.h"
#import "LoginViewController.h"
#import "LoginSingleton.h"
#import "SciProMobileAppDelegate.h"
#import "JSON.h"


@implementation AvailableChecker

- (void)available{
    responseData = [[NSMutableData data] retain];
    NSMutableString *url = [[NSMutableString alloc] initWithString:[LoginSingleton getAddress]];
    [url appendString:@"json/status?userid="];
    [url appendString:[[LoginSingleton instance].user.userId stringValue]];
	[url appendString:@"&apikey="];
    [url appendString:[LoginSingleton instance].apikey];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [url release];
    NSURLConnection *conn= [[NSURLConnection alloc] initWithRequest:request delegate:self];  
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
