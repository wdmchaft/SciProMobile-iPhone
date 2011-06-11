//
//  ProjectModel.m
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
