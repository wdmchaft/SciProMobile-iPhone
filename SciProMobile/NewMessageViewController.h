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
    UITextField *toTextField;
}
@property (nonatomic, retain) IBOutlet UITextField *toTextField;

@property (nonatomic, retain) IBOutlet UITextField *subjectTextField;
@property (nonatomic, retain) IBOutlet UITextView *messageTextView;
- (IBAction)sendAction:(id)sender;
- (IBAction)searchField:(id)sender;

@end
