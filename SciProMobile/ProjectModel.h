//
//  ProjectModel.h
//  SciProMobile
//
//  Created by Johan Aschan on 2011-04-19.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum status{
    NEEDHELP,
    NEUTRAL,
    FINE,
} Status;

@interface ProjectModel : NSObject {
    
    NSString *title;
    NSString *statusMessage;
    NSMutableArray *projectMembers;
    NSMutableArray *reviewers;
    NSMutableArray *coSupervisors;
    NSString *level;
    NSString *reviewer;
    Status status;
}


@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *statusMessage;
@property (nonatomic, retain) NSMutableArray *projectMembers;
@property (nonatomic, retain) NSMutableArray *reviewers;
@property (nonatomic, retain) NSMutableArray *coSupervisors;
@property (nonatomic, retain) NSString *level;
@property (nonatomic, assign) Status status;

- (id)initWithTitle:(NSString *)title statusMessage:(NSString *)statusMessage status:(Status)status members:(NSMutableArray *)members level:(NSString *)level reviewer:(NSMutableArray *) reviewers coSupervisors:(NSMutableArray *) coSupervisors ;
- (NSComparisonResult) sortByStatus:(ProjectModel *)obj;

@end
