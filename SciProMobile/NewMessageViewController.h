//
//  CreateMessageViewController.h
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

#import <UIKit/UIKit.h>


@interface NewMessageViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate> {
    UITextField *subjectTextField;
    NSMutableData *responseData;
    NSMutableArray *projectUsers;
    UITextField *toTextField;
    UITextView *textView;
    BOOL projectSend;
}
@property (nonatomic, retain) IBOutlet UITextField *toTextField;
@property (nonatomic, retain) IBOutlet UITextView *textView;

@property (nonatomic, retain) IBOutlet UITextField *subjectTextField;
@property (nonatomic, retain) NSMutableArray *projectUsers;
@property (nonatomic, assign) BOOL projectSend;

- (IBAction)sendAction:(id)sender;
- (IBAction)searchField:(id)sender;
- (BOOL)newMessageWithSubject: (NSString*) subject andMessage:(NSString*) message andUserArray: (NSMutableArray*) toUserIdArray;

@end
