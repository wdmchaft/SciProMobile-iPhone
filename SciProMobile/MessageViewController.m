//
//  MessageViewController.m
//  SciProMobile
//
//  Created by Johan Aschan on 2011-04-07.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import "MessageViewController.h"
#import "CreateMessageViewController.h"
#import "MessageModel.h"
#import "MessageDetailViewController.h"
#import "SearchViewController.h"

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    
    UIBarButtonItem* infoButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showInfoView:)];
	self.navigationItem.leftBarButtonItem = infoButton;
    
    [infoButton release];

    NSString *message = @"Tenta den 15:de maj GNU gdb 6.3.50-20050815 (Apple version gdb-1518)ccccccccccccccccccc ddddddddddddddddddddd ffffffffffffffff fffffffffff   dddddddddd";

    
    NSDate *date = [NSDate date];
    
    MessageModel *firstMess = [[MessageModel alloc] initWithFrom:@"Patrick Strang" subject:@"Tenta på fredag" message:message date:date];
    MessageModel *secondMess = [[MessageModel alloc] initWithFrom:@"Jan Moberg" subject:@"Seminarie på fredag" message:message date:[NSDate date]];
    MessageModel *thirdMess = [[MessageModel alloc] initWithFrom:@"Henrik Hansson" subject:@"Innebandy på fredag" message:message date:[NSDate date]];
    
    messages = [[NSMutableArray alloc]initWithObjects:firstMess,secondMess,thirdMess,nil];
    
    // Do any additional setup after loading the view from its nib.
}


- (void) showInfoView:(id)sender
{
    CreateMessageViewController *createMessageViewController = [[CreateMessageViewController alloc] init];
    createMessageViewController.title = @"Create message";
    [self.navigationController pushViewController:createMessageViewController animated:YES];
    [createMessageViewController release]; 
    
//    SearchViewController *searchViewController = [[SearchViewController alloc] init];
//    searchViewController.title = @"Search User";
//    [self.navigationController pushViewController:searchViewController animated:YES];
//    [searchViewController release]; 
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return [messages count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.;
    return @"Inbox";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier] autorelease];
    }
    MessageModel *messageModel = [messages objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = messageModel.subject;
    cell.detailTextLabel.text = messageModel.message;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel *messageModel = [messages objectAtIndex:indexPath.row];
    MessageDetailViewController *messageDetailViewController = [[MessageDetailViewController alloc] init];
    messageDetailViewController.title = messageModel.subject;


    [self.navigationController pushViewController:messageDetailViewController animated:YES];
    [messageDetailViewController.subject setText:messageModel.subject];
    [messageDetailViewController.textView setText:messageModel.message];
    [messageDetailViewController.from setText:messageModel.from];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"]; 
    messageDetailViewController.date.text = [dateFormatter stringFromDate:messageModel.sentDate];
    [dateFormatter release];;
    [messageDetailViewController release];
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {    
    return UITableViewCellEditingStyleDelete;
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list. 
    if (editingStyle == UITableViewCellEditingStyleDelete  && (indexPath.section == 0)) {
        MessageModel *messageModel = [messages objectAtIndex:indexPath.row];
        [messages removeObject:messageModel];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (void)dealloc{   
    [messages release];
    [super dealloc];
}

@end
