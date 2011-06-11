//
//  ProjectModel.h
//  SciProMobile
//
/*
 * Copyright (c) 2011 Johan Aschan.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
    NSMutableArray *finalSeminars;
    NSString *level;
    NSString *reviewer;
    Status status;
    NSNumber *progress;
}


@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *statusMessage;
@property (nonatomic, retain) NSMutableArray *projectMembers;
@property (nonatomic, retain) NSMutableArray *reviewers;
@property (nonatomic, retain) NSMutableArray *coSupervisors;
@property (nonatomic, retain) NSMutableArray *finalSeminars;
@property (nonatomic, retain) NSString *level;
@property (nonatomic, retain) NSNumber *progress;
@property (nonatomic, assign) Status status;

- (id)initWithTitle:(NSString *)title statusMessage:(NSString *)statusMessage status:(Status)status members:(NSMutableArray *)members level:(NSString *)level reviewer:(NSMutableArray *) reviewers coSupervisors:(NSMutableArray *) coSupervisors progress:(NSNumber *) progress finalSeminars:(NSMutableArray *) finalSeminars  ;
- (NSComparisonResult) sortByStatus:(ProjectModel *)obj;

@end
