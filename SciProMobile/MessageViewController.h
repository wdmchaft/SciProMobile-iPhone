//
//  MessageViewController.h
//  SciProMobile
//
//  Created by Johan Aschan on 2011-04-07.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MessageViewController : UITableViewController {
    NSMutableData *responseData;
    NSMutableArray *messages;
    BOOL inbox;
    UIActivityIndicatorView *activityIndicator;
}
@property (nonatomic, assign) BOOL inbox;
- (void)updateView;
- (void)setRead: (NSNumber*) recipientId;
- (void)deleteMessage: (NSNumber*) recipientId;
- (void)unreadMessages;
@end
