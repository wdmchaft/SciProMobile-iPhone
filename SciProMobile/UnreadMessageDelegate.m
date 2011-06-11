
//
//  UnreadMessageDelegate.m
//  SciProMobile
//
/*
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

#import "UnreadMessageDelegate.h"
#import "JSON.h"
#import "LoginViewController.h"
#import "LoginSingleton.h"


@implementation UnreadMessageDelegate
@synthesize tabBarItem;


- (id)init{	
	if ((self = [super init])) {
        responseData = [[NSMutableData data] retain];
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
    if (projectDictionary == nil)
		[NSString stringWithFormat:@"JSON parsing failed: %@", [error localizedDescription]];
	else {
        NSString *apiCheck = [projectDictionary objectForKey:@"apikey"];
        
        if ([apiCheck isEqualToString:@"success"]){
            if([[projectDictionary objectForKey:@"unreadmess"] isEqualToNumber: [NSNumber numberWithInt:0]]){
                tabBarItem.badgeValue = nil;
            }else{
                tabBarItem.badgeValue = [[projectDictionary objectForKey:@"unreadmess"] stringValue];
            }
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
