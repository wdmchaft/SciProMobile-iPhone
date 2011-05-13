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
@synthesize messageId;
@synthesize read;

- (id)initWithMessageId:(NSNumber *)messageId  From:(UserModel *)from subject:(NSString *)subject message:(NSString *)message date:(NSString *)date read: (BOOL)read{
	
	if ((self = [super init])) {
		self.from = from;
        self.subject = subject;
        self.message = message;
        self.sentDate = date;
        self.messageId = messageId;
        self.read = read;
	}
	return self;
}


- (void)dealloc {
    [messageId release];
	[from release];
	[subject release];
	[message release];
    [sentDate release];
	[super dealloc];
}



@end
