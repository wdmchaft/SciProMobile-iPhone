//
//  MessageModel.h
//  SciProMobile
//
//  Created by Johan Aschan on 2011-04-18.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"


@interface MessageModel : NSObject {
    
    UserModel *from;
    BOOL read;
    NSString *subject;
    NSString *message;
    NSString *sentDate;
    NSNumber *messageId;
    NSMutableArray *toUsers;
    
}

@property (nonatomic, retain) UserModel *from;;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *sentDate;
@property (nonatomic, retain) NSNumber *messageId;
@property (nonatomic, retain) NSMutableArray *toUsers;
@property (nonatomic, assign) BOOL read;

- (id)initWithMessageId:(NSNumber *)messageId  From:(UserModel *)from subject:(NSString *)subject message:(NSString *)message date:(NSString *)date read: (BOOL)read toUsers:(NSMutableArray *) toUsers;

@end
