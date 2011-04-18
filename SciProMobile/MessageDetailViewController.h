//
//  MessageDetailViewController.h
//  SciProMobile
//
//  Created by Johan Aschan on 2011-04-18.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MessageDetailViewController : UIViewController {
    
    UILabel *from;
    UILabel *date;
    UILabel *subject;
    UITextView *textView;
}
@property (nonatomic, retain) IBOutlet UILabel *from;
@property (nonatomic, retain) IBOutlet UILabel *date;
@property (nonatomic, retain) IBOutlet UILabel *subject;
@property (nonatomic, retain) IBOutlet UITextView *textView;

@end
