//
//  FinalSeminarModel.h
//  SciProMobile
//
//  Created by Johan Aschan on 2011-05-16.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FinalSeminarModel : NSObject {
    NSString *room;
    NSString *date;
    NSMutableArray *opponents;
    NSMutableArray *activeListeners;
}


@property (nonatomic, retain) NSString *room;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSMutableArray *opponents;;
@property (nonatomic, retain) NSMutableArray *activeListeners;


- (id)initWithRoom:(NSString *)room date:(NSString *)date opponents: (NSMutableArray *) opponents activeListeners: (NSMutableArray *) activeListeners;
@end
