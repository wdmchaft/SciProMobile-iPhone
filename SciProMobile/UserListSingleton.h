//
//  UserListSingleton.h
//  SciProMobile
//
//  Created by Johan Aschan on 2011-05-13.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserListSingleton : NSObject {
    
    NSMutableArray *mutableArray;    
}


@property (nonatomic, retain) NSMutableArray *mutableArray;

+ (UserListSingleton *)instance;

@end
