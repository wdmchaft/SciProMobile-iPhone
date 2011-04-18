//
//  MessageModel.m
//  SciProMobile
//
//  Created by Johan Aschan on 2011-04-18.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import "MessageModel.h"


@implementation MessageModel

@synthesize from;
@synthesize subject;
@synthesize message;
@synthesize sentDate;


- (id)initWithFrom:(NSString *)from subject:(NSString *)subject message:(NSString *)message date:(NSDate *)date     {
	
	if ((self = [super init])) {
		self.from = from;
        self.subject = subject;
        self.message = message;
        sentDate = date;
	}
	return self;
}


- (void)dealloc {
	[from release];
	[subject release];
	[message release];
    [sentDate release];
	[super dealloc];
}



@end
