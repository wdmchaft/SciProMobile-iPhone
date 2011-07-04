//
//  LoginModel.m
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

#import "LoginSingleton.h"


@implementation LoginSingleton
@synthesize apikey;
@synthesize user, iphoneId;
static LoginSingleton *gInstance = NULL;
static NSString* address = @"https://thesis.dsv.su.se/scipro2/";
 
+ (LoginSingleton *)instance
{
    @synchronized(self)
    {
        if (gInstance == NULL)
            gInstance = [[self alloc] init];
    }
    return(gInstance);
}

- (void)dealloc {
    [iphoneId release];
	[apikey release];
	[user release];
	[super dealloc];
}

+ (NSString*)getAddress{
    return address;
}

@end
