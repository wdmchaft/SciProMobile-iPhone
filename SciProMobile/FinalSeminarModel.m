//
//  FinalSeminarModel.m
//  SciProMobile
//
//  Created by Johan Aschan on 2011-05-16.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import "FinalSeminarModel.h"


@implementation FinalSeminarModel
@synthesize room;
@synthesize date;
@synthesize activeListeners;
@synthesize opponents;

- (id)initWithRoom:(NSString *)room date:(NSString *)date opponents: (NSMutableArray *) opponents activeListeners: (NSMutableArray *) activeListeners {
	
	if ((self = [super init])) {
		self.room = room;
        self.date = date;
        self.opponents = opponents;
        self.activeListeners = activeListeners;
        
	}
	return self;
}


- (void)dealloc {
	[room release];
	[date release];
    [opponents release];
    [activeListeners release];
	[super dealloc];
}

@end
