//
//  MessageModel.h
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
