//
//  SetReadDelegate.h
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
