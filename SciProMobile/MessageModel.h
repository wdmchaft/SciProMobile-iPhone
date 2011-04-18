//
//  MessageModel.h
//  SciProMobile
//
//  Created by Johan Aschan on 2011-04-18.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MessageModel : NSObject {
    
    NSString *from;
    NSString *subject;
    NSString *message;
    NSDate *sentDate;
}

@property (nonatomic, retain) NSString *from;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSDate *sentDate;

- (id)initWithFrom:(NSString *)from subject:(NSString *)subject message:(NSString *)message date:(NSDate *)date;

@end
