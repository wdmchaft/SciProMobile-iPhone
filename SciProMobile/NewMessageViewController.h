//
//  CreateMessageViewController.h
//  SciProMobile
//
//  Created by Johan Aschan on 2011-04-07.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewMessageViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate> {
    UITextField *subjectTextField;
    UITextView *messageTextView;
    NSMutableData *responseData;
    NSMutableArray *projectUsers;
    UITextField *toTextField;
    BOOL projectSend;
}
@property (nonatomic, retain) IBOutlet UITextField *toTextField;

@property (nonatomic, retain) IBOutlet UITextField *subjectTextField;
@property (nonatomic, retain) IBOutlet UITextView *messageTextView;
@property (nonatomic, retain) NSMutableArray *projectUsers;
@property (nonatomic, assign) BOOL projectSend;
- (IBAction)sendAction:(id)sender;
- (IBAction)searchField:(id)sender;
- (BOOL)newMessageWithSubject: (NSString*) subject andMessage:(NSString*) message andUserArray: (NSMutableArray*) toUserIdArray;

@end
