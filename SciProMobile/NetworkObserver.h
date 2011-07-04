//
//  NetworkObserver.h
//  SciPro
//
//  Created by idlab1 on 2011-07-04.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Reachability;

@interface NetworkObserver : NSObject {
    Reachability* internetReachable;
    Reachability* hostReachable;
    BOOL internetActive;
    BOOL hostActive;
}

@property (nonatomic, assign) BOOL internetActive;
@property (nonatomic, assign) BOOL hostActive;
- (void) checkNetworkStatus:(NSNotification *)notice;
@end
