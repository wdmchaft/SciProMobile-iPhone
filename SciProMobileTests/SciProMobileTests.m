//
//  SciProMobileTests.m
//  SciProMobileTests
//
//  Created by Johan Aschan on 2011-03-30.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import "SciProMobileTests.h"


@implementation SciProMobileTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    NSString *string1 = @"test";
    NSString *string2 = @"test";
    STAssertEquals(string1,
                   string2,
                   @"FAILURE");
    NSUInteger uint_1 = 4;
    NSUInteger uint_2 = 4;
    STAssertEquals(uint_1,
                   uint_2,
                   @"FAILURE");
    
}

@end
