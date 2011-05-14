//
//  UserModel.h
//  SciProMobile
//
//  Created by Johan Aschan on 2011-05-11.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserModel : NSObject {
    
    NSString *name;
    NSNumber *userId;

}


@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *userId;


- (id)initWithId:(NSNumber *)userId name:(NSString *)name ;
- (NSComparisonResult) sortByName:(UserModel *)obj;
@end
