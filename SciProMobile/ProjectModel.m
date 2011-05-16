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
@synthesize projectMembers;
@synthesize level;
@synthesize reviewers;
@synthesize coSupervisors;
@synthesize progress;
@synthesize finalSeminars;

- (id)initWithTitle:(NSString *)title statusMessage:(NSString *)statusMessage status:(Status)status members:(NSMutableArray *)members level:(NSString *)level reviewer:(NSMutableArray *) reviewers coSupervisors:(NSMutableArray *) coSupervisors progress:(NSNumber *) progress finalSeminars:(NSMutableArray *) finalSeminars {
	
	if ((self = [super init])) {
		self.title = title;
        self.statusMessage = statusMessage;
        self.status = status;
        self.projectMembers = members;
        self.level = level;
        self.reviewers = reviewers;
        self.coSupervisors = coSupervisors;
        self.progress = progress;
        self.finalSeminars = finalSeminars;
	}
	return self;
}

- (NSComparisonResult) sortByStatus:(ProjectModel *)obj
{
    NSComparisonResult retVal = NSOrderedSame;
    if ( self.status == NEEDHELP && obj.status == FINE ) // by whatever rules make sense for your class of course
        retVal = NSOrderedAscending;
    else if ( self.status == NEEDHELP && obj.status == NEUTRAL ) 
        retVal = NSOrderedAscending;
    else if ( self.status == NEUTRAL && obj.status == NEEDHELP ) 
        retVal = NSOrderedDescending;
    else if ( self.status == FINE && obj.status == NEEDHELP ) 
        retVal = NSOrderedDescending;
    else if ( self.status == FINE && obj.status == NEUTRAL ) 
        retVal = NSOrderedDescending;
    return retVal;
}

- (void)dealloc {
	[title release];
	[statusMessage release];
    [projectMembers release];
    [coSupervisors release];
    [reviewers release];
    [level release];
    [progress release];
    [finalSeminars release];
	[super dealloc];
}

@end
