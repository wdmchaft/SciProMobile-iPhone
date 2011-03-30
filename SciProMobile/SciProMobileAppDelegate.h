//
//  SciProMobileAppDelegate.h
//  SciProMobile
//
//  Created by Johan Aschan on 2011-03-30.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SciProMobileViewController;

@interface SciProMobileAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet SciProMobileViewController *viewController;

@end
