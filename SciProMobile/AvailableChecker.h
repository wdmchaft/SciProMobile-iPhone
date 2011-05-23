//
//  AvailableChecker.h
//  SciPro
//
//  Created by Johan Aschan on 2011-05-23.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AvailableChecker : NSObject {
    NSMutableData *responseData;
}
- (void)available;
@end
