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
@synthesize userid;
static LoginSingleton *gInstance = NULL;

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
	[apikey release];
	[userid release];
	[super dealloc];
}

@end