//
//  SetReadDelegate.h
//  SciProMobile
//
//  Created by Johan Aschan on 2011-05-16.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PostDelegate : NSObject {
    NSMutableData *responseData;
    BOOL successAlert;
    NSString *successMessage;
    NSString *successTitle;
}

@property (nonatomic, assign) BOOL successAlert;
@property (nonatomic, retain) NSString *successMessage;
@property (nonatomic, retain) NSString *successTitle;

@end
