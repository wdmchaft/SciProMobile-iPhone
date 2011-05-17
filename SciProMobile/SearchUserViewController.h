//
//  SearchUserViewController.h
//  SciProMobile
//
//  Created by Johan Aschan on 2011-04-21.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewMessageViewController.h"

@interface SearchUserViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate> {
    
    UITableView *tableView;
    NSMutableArray *contentsList;
    NSMutableArray *searchResults;
    NSString *savedSearchTerm;
    NewMessageViewController *createMessageViewController;
    
}
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *contentsList;
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic, retain) NewMessageViewController *createMessageViewController;

- (void)handleSearchForTerm:(NSString *)searchTerm;
- (void)setupLocation;

@end
