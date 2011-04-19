//
//  ProjectModel.h
//  SciProMobile
//
//  Created by Johan Aschan on 2011-04-19.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum status{
    GREEN,
    YELLOW,
    RED,
} Status;

@interface ProjectModel : NSObject {
    
    NSString *title;
    NSString *statusMessage;
    Status status;
}


@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *statusMessage;
@property (nonatomic, assign) Status status;

- (id)initWithTitle:(NSString *)title statusMessage:(NSString *)statusMessage status:(Status)status;
- (NSComparisonResult) sortByStatus:(ProjectModel *)obj;

@end
