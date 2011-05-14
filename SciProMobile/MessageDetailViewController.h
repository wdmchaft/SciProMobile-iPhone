//
//  MessageDetailViewController.h
//  SciProMobile
//
//  Created by Johan Aschan on 2011-04-18.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface MessageDetailViewController : UITableViewController {
    
    MessageModel *messageModel;

}
@property (nonatomic, retain) MessageModel *messageModel;;
- (void)getUnreadMessageNumber;

@end
