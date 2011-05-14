//
//  UserListSingleton.m
//  SciProMobile
//
//  Created by Johan Aschan on 2011-05-13.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import "UserListSingleton.h"


@implementation UserListSingleton
@synthesize mutableArray;
static UserListSingleton *gInstance = NULL;

+ (UserListSingleton *)instance
{
    @synchronized(self)
    {
        if (gInstance == NULL)
            gInstance = [[self alloc] init];
    }
    return(gInstance);
}

- (void)dealloc {
	[mutableArray release];
	[super dealloc];
}

@end

