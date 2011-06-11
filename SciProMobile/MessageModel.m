//
//  MessageModel.m
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

#import "MessageModel.h"


@implementation MessageModel

@synthesize from;
@synthesize subject;
@synthesize message;
@synthesize sentDate;
@synthesize messageId;
@synthesize read;
@synthesize toUsers;

- (id)initWithMessageId:(NSNumber *)messageId  From:(UserModel *)from subject:(NSString *)subject message:(NSString *)message date:(NSString *)date read: (BOOL)read  toUsers:(NSMutableArray *) toUsers{
	
	if ((self = [super init])) {
		self.from = from;
        self.subject = subject;
        self.message = message;
        self.sentDate = date;
        self.messageId = messageId;
        self.read = read;
        self.toUsers = toUsers;
	}
	return self;
}


- (void)dealloc {
    [messageId release];
	[from release];
	[subject release];
	[message release];
    [sentDate release];
    [toUsers release];
	[super dealloc];
}



@end
