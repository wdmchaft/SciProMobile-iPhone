//
//  ProjectDetailViewController.m
//  SciProMobile
//
//  Created by Johan Aschan on 2011-04-07.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import "FinalSeminarViewController.h"
#import "ProjectModel.h"
#import "UserModel.h"
#import "NewMessageViewController.h"
#import "UnreadMessageDelegate.h"
#import "LoginSingleton.h"
#import "LoginViewController.h"
#import "FinalSeminarModel.h"

@implementation FinalSeminarViewController
@synthesize finalSeminarModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    [finalSeminarModel release];
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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)messageToProject:(id)sender {
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [finalSeminarModel.opponents count];
            break;
        case 1:
            return [finalSeminarModel.activeListeners count];;
            break;
    }
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.;
    switch (section) {
            
        case 0:
            return @"Opponents";
            break;
        case 1:
            return @"Active Particpants";
            break;
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier] autorelease];
    }
    
    NSMutableArray *array;
    switch (indexPath.section) {
        case 0:
            array = finalSeminarModel.opponents;
            break;
        case 1:
            array = finalSeminarModel.activeListeners;
            break;
    }
    UserModel *userModel = [array objectAtIndex:indexPath.row];
    cell.textLabel.text = userModel.name;
    cell.detailTextLabel.text = nil;
    cell.imageView.image = nil;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array;
    switch (indexPath.section) {
        case 0:
            array = finalSeminarModel.opponents;
            break;
        case 1:
            array = finalSeminarModel.activeListeners;
            break;
    }
    
    NewMessageViewController *createMessageViewController = [[NewMessageViewController alloc] init];
    createMessageViewController.title = @"New message";
    [self.navigationController pushViewController:createMessageViewController animated:YES];
    UserModel *userModel = [array objectAtIndex:indexPath.row];
    createMessageViewController.toTextField.text = userModel.name;
    [createMessageViewController release]; 
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}


@end
