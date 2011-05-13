//
//  LoginModel.h
//  SciProMobile
//
//  Created by Johan Aschan on 2011-05-12.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LoginSingleton : NSObject {
    
    NSString *apikey;
    NSNumber *userid;
   
}


@property (nonatomic, retain) NSString *apikey;
@property (nonatomic, retain) NSNumber *userid;


+ (LoginSingleton *)instance;

@end
