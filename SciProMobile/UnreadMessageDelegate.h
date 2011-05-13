//
//  UnreadMessageDelegate.h
//  SciProMobile
//
//  Created by Johan Aschan on 2011-05-12.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UnreadMessageDelegate : NSObject {
    NSMutableData *responseData;
    UITabBarItem *tabBarItem;
}
@property (nonatomic, retain) UITabBarItem *tabBarItem;
@end
