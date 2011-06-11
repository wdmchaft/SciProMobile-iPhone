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

#import "UserModel.h"


@implementation UserModel



@synthesize userId;
@synthesize name;

- (id)initWithId:(NSNumber *)userId name:(NSString *)name{
	
	if ((self = [super init])) {
		self.userId = userId;
        self.name = name;

	}
	return self;
}

- (NSComparisonResult) sortByName:(UserModel *)obj
{
    return [self.name localizedCaseInsensitiveCompare: obj.name];
}
- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToWidget:other];
}

- (BOOL)isEqualToWidget:(UserModel *)aWidget {
    if (self == aWidget)
        return YES;
    if (![(id)[self userId] isEqual:[aWidget userId]])
        return NO;
    return YES;
}



- (void)dealloc {
	[userId release];
	[name release];
	[super dealloc];
}

@end
