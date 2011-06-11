//
//  FinalSeminarModel.m
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
