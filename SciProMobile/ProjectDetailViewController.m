//
//  ProjectDetailViewController.m
//  SciProMobile
//
//  Created by Johan Aschan on 2011-04-07.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import "ProjectDetailViewController.h"
#import "ProjectModel.h"
#import "UserModel.h"
#import "NewMessageViewController.h"

@implementation ProjectDetailViewController
@synthesize projectModel;

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
    [projectModel release];
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
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            
            if([projectModel.statusMessage isEqual:@""])
                return 0;
            else
                return 1;
            break;
        case 3:
            return[projectModel.projectMembers count];
            break;
        case 4:
            return[projectModel.reviewers count];
            break;
        case 5:
            return[projectModel.coSupervisors count];
            break;
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.;
    switch (section) {
            
        case 0:
            return @"Project Title";
            break;
        case 1:
            return @"Status";
            break;
        case 2:
            return @"Status Message";
            break;
        case 3:
            return @"Project Members";
            break;
        case 4:
            return @"Reviewers";
            break;
        case 5:
            return @"Co-Supervisors";
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
    
    if(indexPath.section == 0){
        cell.textLabel.text = projectModel.title;
        cell.textLabel.numberOfLines=0;
        cell.detailTextLabel.text = projectModel.level;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = nil;
        
    } else if(indexPath.section == 1){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.text = nil;
        cell.accessoryType = UITableViewCellAccessoryNone;
        switch (projectModel.status) {
            case NEEDHELP:
                cell.imageView.image = [UIImage imageNamed:@"red_ball_small.png"];
                cell.textLabel.text = @"Need Help";
                break;
            case FINE:
                cell.imageView.image = [UIImage imageNamed:@"green_ball_small.png"];
                cell.textLabel.text = @"Fine";
                break;
            default:
                cell.imageView.image = [UIImage imageNamed:@"yellow_ball_small.png"];
                cell.textLabel.text = @"Neutral";
                break;
        }
        
    } else if(indexPath.section == 2){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = projectModel.statusMessage;
        cell.textLabel.numberOfLines=0;
        cell.detailTextLabel.text = nil;
        cell.imageView.image = nil;

    } else{
        NSMutableArray *array;
        switch (indexPath.section) {
            case 3:
                array = projectModel.projectMembers;
                break;
            case 4:
                array = projectModel.reviewers;
                break;
            case 5:
                array = projectModel.coSupervisors;
                break;
        }
        UserModel *userModel = [array objectAtIndex:indexPath.row];
        cell.textLabel.text = userModel.name;
        cell.detailTextLabel.text = nil;
        cell.imageView.image = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array;
    switch (indexPath.section) {
        case 3:
            array = projectModel.projectMembers;
            break;
        case 4:
            array = projectModel.reviewers;
            break;
        case 5:
            array = projectModel.coSupervisors;
            break;
    }
    
    NewMessageViewController *createMessageViewController = [[NewMessageViewController alloc] init];
    createMessageViewController.title = @"New message";
    [self.navigationController pushViewController:createMessageViewController animated:YES];
    
    if(indexPath.section == 0){
        array = [[NSMutableArray alloc] init];
        [array addObjectsFromArray:projectModel.projectMembers];
        [array addObjectsFromArray:projectModel.reviewers];
        [array addObjectsFromArray:projectModel.coSupervisors];
        [array sortUsingSelector:@selector(sortByName:)];
        createMessageViewController.projectSend = YES;
        createMessageViewController.projectUsers = array;
        
        
        NSMutableString *usernamestring = [[NSMutableString alloc] init];
        BOOL first = YES;
        for(unsigned int i = 0; i < [array count]; i++){
            UserModel *user = [array objectAtIndex:i];
            if(first){
                [usernamestring appendString:user.name];
                first = NO;
            } else{
                [usernamestring appendString:@", "];
                [usernamestring appendString:user.name];
            }
        }
        createMessageViewController.toTextField.text = usernamestring;
        [usernamestring release];
    } else{
        UserModel *userModel = [array objectAtIndex:indexPath.row];
        createMessageViewController.toTextField.text = userModel.name;
    }
    [createMessageViewController release]; 
}
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    // Determine if row is selectable based on the NSIndexPath.
    
    if (path.section == 0 || path.section == 3 || path.section == 4 || path.section == 5)
    {
        return path;
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        NSString *title = projectModel.title;
        UIFont *font = [UIFont boldSystemFontOfSize:18];
        CGSize titleSize = {0, 0};
        titleSize = [title sizeWithFont:font
                      constrainedToSize:CGSizeMake(270.0f, FLT_MAX) lineBreakMode:UILineBreakModeWordWrap];
        float height = titleSize.height;
        NSLog(@"%f", titleSize.height);
        
        height += 50;
        
        return height;
    } else if (indexPath.section == 2){
        NSString *title = @"";
        UIFont *font = [UIFont boldSystemFontOfSize:18];
        CGSize titleSize = {0, 0};
        titleSize = [title sizeWithFont:font
                      constrainedToSize:CGSizeMake(270.0f, FLT_MAX)];
        float height = titleSize.height;
        NSLog(@"%f", titleSize.height);
        
        height += 50;
        
        return height;
    } else{
        return 44;
    }
    
    
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
