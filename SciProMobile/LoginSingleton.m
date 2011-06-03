//
//  LoginModel.m
//  SciProMobile
//
//  Created by Johan Aschan on 2011-05-12.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import "LoginSingleton.h"


@implementation LoginSingleton
@synthesize apikey;
@synthesize user, iphoneId;
static LoginSingleton *gInstance = NULL;
static NSString* address = @"http://130.229.152.93:8080";
 
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
