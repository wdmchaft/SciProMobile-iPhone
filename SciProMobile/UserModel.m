//
//  ProjectModel.m
//  SciProMobile
//
//  Created by Johan Aschan on 2011-04-19.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

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
    NSComparisonResult retVal = NSOrderedSame;
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
