//
//  SearchUserViewController.m
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

#import "SearchUserViewController.h"
#import "UserListSingleton.h"
#import "UserModel.h"
#import "UnreadMessageDelegate.h"
#import "LoginSingleton.h"
#import "LoginViewController.h"

@implementation SearchUserViewController
@synthesize tableView;
@synthesize contentsList;
@synthesize searchResults;
@synthesize savedSearchTerm;
@synthesize createMessageViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [tableView release];
    [contentsList release];
    [searchResults release];
    [savedSearchTerm release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableArray *array = [UserListSingleton instance].mutableArray; 
    [array sortUsingSelector:@selector(sortByName:)];
    NSMutableArray *stringArray = [[NSMutableArray alloc] init];
    
    for(unsigned int i = 0; i < [array count]; i++){
        UserModel *userModel = [array objectAtIndex:i];
        [stringArray addObject:userModel.name];
    }
    [self setContentsList:stringArray];
    [stringArray release];
    // Do any additional setup after loading the view from its nib.
    
    // Restore search term
    if ([self savedSearchTerm])
    {
        [[[self searchDisplayController] searchBar] setText:[self savedSearchTerm]];
    }
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self setSavedSearchTerm:[[[self searchDisplayController] searchBar] text]];
	
    [self setSearchResults:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    
	
    [super viewWillAppear:animated];
	
    [[self tableView] reloadData];
}

- (void)handleSearchForTerm:(NSString *)searchTerm{
    
    [self setSavedSearchTerm:searchTerm];
	
    if ([self searchResults] == nil)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [self setSearchResults:array];
        [array release], array = nil;
    }
	
    [[self searchResults] removeAllObjects];
	
    if ([[self savedSearchTerm] length] != 0){
        for (NSString *currentString in [self contentsList]){
            if ([currentString rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound){
                [[self searchResults] addObject:currentString];
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows;
	
    if (tableView == [[self searchDisplayController] searchResultsTableView])
        rows = [[self searchResults] count];
    else
        rows = [[self contentsList] count];
	
    return rows;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    NSString *contentForThisRow = nil;
	
    if (tableView == [[self searchDisplayController] searchResultsTableView])
        contentForThisRow = [[self searchResults] objectAtIndex:row];
    else
        contentForThisRow = [[self contentsList] objectAtIndex:row];
	
    static NSString *CellIdentifier = @"CellIdentifier";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
    [[cell textLabel] setText:contentForThisRow];
	
    return cell;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    
    [self handleSearchForTerm:searchString];
    return YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [self setSavedSearchTerm:nil];
	
    [[self tableView] reloadData];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSString *contentForThisRow = nil;
	
    if (tableView == [[self searchDisplayController] searchResultsTableView])
        contentForThisRow = [[self searchResults] objectAtIndex:row];
    else
        contentForThisRow = [[self contentsList] objectAtIndex:row];
    createMessageViewController.toTextField.text = contentForThisRow;
    [self.navigationController popViewControllerAnimated:YES]; 
	
}




@end

