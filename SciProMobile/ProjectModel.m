//
//  ProjectModel.m
//  SciProMobile
//
//  Created by Johan Aschan on 2011-04-19.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import "ProjectModel.h"


@implementation ProjectModel



@synthesize title;
@synthesize statusMessage;
@synthesize status;


- (id)initWithTitle:(NSString *)title statusMessage:(NSString *)statusMessage status:(Status)status {
	
	if ((self = [super init])) {
		self.title = title;
        self.statusMessage = statusMessage;
        self.status = status;
	}
	return self;
}

- (NSComparisonResult) sortByStatus:(ProjectModel *)obj
{
    NSComparisonResult retVal = NSOrderedSame;
    if ( self.status == RED && obj.status == GREEN ) // by whatever rules make sense for your class of course
        retVal = NSOrderedAscending;
    else if ( self.status == RED && obj.status == YELLOW ) 
        retVal = NSOrderedAscending;
    else if ( self.status == YELLOW && obj.status == RED ) 
        retVal = NSOrderedDescending;
    else if ( self.status == GREEN && obj.status == RED ) 
        retVal = NSOrderedDescending;
    else if ( self.status == GREEN && obj.status == YELLOW ) 
        retVal = NSOrderedDescending;
    return retVal;
}

- (void)dealloc {
	[title release];
	[statusMessage release];
	[super dealloc];
}

@end
