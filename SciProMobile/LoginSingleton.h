//
//  LoginModel.h
//  SciProMobile
//
//  Created by Johan Aschan on 2011-05-12.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"


@interface LoginSingleton : NSObject {
    
    NSString *apikey;
    NSString *iphoneId;
    UserModel *user;
   
}


@property (nonatomic, retain) NSString *apikey;
@property (nonatomic, retain) NSString *iphoneId;
@property (nonatomic, retain) UserModel *user;


+ (LoginSingleton *)instance;
+ (NSString*)getAddress;
@end
