//
//  SetReadDelegate.h
//  SciProMobile
//
//  Created by Johan Aschan on 2011-05-16.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageViewController.h"

@interface PostDelegate : NSObject {
    NSMutableData *responseData;
    BOOL successAlert;
    BOOL message;
    NSString *successMessage;
    NSString *successTitle;
    MessageViewController *messageViewController;
}

@property (nonatomic, assign) BOOL successAlert;
@property (nonatomic, assign) BOOL message;
@property (nonatomic, retain) NSString *successMessage;
@property (nonatomic, retain) NSString *successTitle;
@property (nonatomic, retain) MessageViewController *messageViewController;

@end
