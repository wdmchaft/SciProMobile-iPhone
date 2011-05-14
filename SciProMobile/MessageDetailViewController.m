//
//  MessageDetailViewController.m
//  SciProMobile
//
//  Created by Johan Aschan on 2011-04-18.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "UnreadMessageDelegate.h"
#import "LoginSingleton.h"
#import "CustomMessageCell.h"


@implementation MessageDetailViewController

@synthesize messageModel;

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

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getUnreadMessageNumber];
    //Do Stuff
}

- (void)getUnreadMessageNumber{
    NSMutableString *url = [NSMutableString stringWithString:@"http://localhost:8080/SciPro/json/message/unread?userid="];
    [url appendString:[[LoginSingleton instance].user.userId stringValue]];
	[url appendString:@"&apikey="];
    [url appendString:[LoginSingleton instance].apikey];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    UnreadMessageDelegate *unreadDelegate = [[UnreadMessageDelegate alloc]init];
    unreadDelegate.tabBarItem =  [(UIViewController *)[[self tabBarController].viewControllers objectAtIndex:1] tabBarItem];
	[[NSURLConnection alloc] initWithRequest:request delegate:unreadDelegate];
    [unreadDelegate release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.;
    switch (section) {
            
        case 0:
            return @"From";
            break;
        case 1:
            return @"Date";
            break;
        case 2:
            return @"Subject";
            break;
        case 3:
            return @"Message";
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
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = nil;
            cell.detailTextLabel.text = messageModel.from.name;
            break;
        case 1:
            cell.textLabel.text = nil;
            cell.detailTextLabel.text = messageModel.sentDate;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case 2:
            cell.textLabel.text = nil;
            cell.detailTextLabel.text = messageModel.subject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case 3:
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.text = messageModel.message;;
//            CGSize labelSize = CGSizeMake(250, 50);
//            CGSize theStringSize = [messageModel.message sizeWithFont:cell.detailTextLabel.font constrainedToSize:labelSize lineBreakMode:cell.detailTextLabel.lineBreakMode];
//            cell.textLabel.frame = CGRectMake(cell.detailTextLabel.frame.origin.x, cell.detailTextLabel.frame.origin.y, theStringSize.width, 200);
            

            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    // Determine if row is selectable based on the NSIndexPath.
    
    if (path.section == 0)
    {
        return path;
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3){
        NSString *title = messageModel.message;
        UIFont *font = [UIFont boldSystemFontOfSize:18];
        CGSize titleSize = {0, 0};
        titleSize = [title sizeWithFont:font
                      constrainedToSize:CGSizeMake(270.0f, FLT_MAX)];
        float height = titleSize.height;
        NSLog(@"%f", titleSize.height);
        if (height < 250) {
            return 250;
        }
        return height;
    } else{
        return 44;
    }
    
    
}


@end
