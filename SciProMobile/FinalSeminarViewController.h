//
//  FinalSeminarViewController.h
//  SciProMobile
//
//  Created by Johan Aschan on 2011-05-16.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FinalSeminarModel.h"

@interface FinalSeminarViewController : UITableViewController {

    FinalSeminarModel *finalSeminarModel;
}

@property (nonatomic, retain) FinalSeminarModel *finalSeminarModel;
@end

