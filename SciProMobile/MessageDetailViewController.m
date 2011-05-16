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
#import "NewMessageViewController.h"
#import "UnreadMessageDelegate.h"
#import "LoginViewController.h"

@implementation MessageDetailViewController

@synthesize messageModel, inbox;

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
    [messageModel release];
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //Do Stuff
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(inbox)
        return 1;
    else{
        if(section == 0){
            return [messageModel.toUsers count];
        } else{
            return 1;
        }
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.;
    if(inbox){
        switch (section) {
            case 0:
                return @"From";
                break;
            case 1:
                return @"Message";
                break;
        }
    } else{
        switch (section) {
            case 0:
                return @"To";
                break;
            case 1:
                return @"Message";
                break;
        }
    }
    return nil;
}

#define TEXT_VIEW_HEIGHT 260
#define TEXT_VIEW_WIDTH 275
#define TEXT_VIEW_PADDING 75
#define TEXT_VIEW_FONT_SIZE 14
#define SUBJECT_FONT_SIZE 16
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier] autorelease];
    }
    
    
    switch (indexPath.section) {
        case 0:
            if(inbox){
                cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                cell.textLabel.text = messageModel.from.name;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
            } else{
                cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                UserModel *userModel = [messageModel.toUsers objectAtIndex:indexPath.row];
                cell.textLabel.text = userModel.name;
            }
            
            break;
        case 1:
            cell.detailTextLabel.text = nil;
            cell.textLabel.text = messageModel.subject;
            cell.detailTextLabel.text = messageModel.sentDate;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:SUBJECT_FONT_SIZE];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case 2:
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //            CGSize theStringSize = [messageModel.message sizeWithFont:cell.textLabel.font constrainedToSize:labelSize lineBreakMode:cell.textLabel.lineBreakMode];
            //            
            //            cell.textLabel.frame = CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.y, theStringSize.width, theStringSize.height);
            NSString *title = messageModel.message;
            UIFont *font = [UIFont systemFontOfSize:TEXT_VIEW_FONT_SIZE];
            CGSize titleSize = {0, 0};
            titleSize = [title sizeWithFont:font
                          constrainedToSize:CGSizeMake(TEXT_VIEW_WIDTH, FLT_MAX)];
            float height = titleSize.height;
            if(height < TEXT_VIEW_HEIGHT)
                height = TEXT_VIEW_HEIGHT;
            
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 10, TEXT_VIEW_WIDTH, height+TEXT_VIEW_PADDING )];
            textView.editable = NO;
            textView.scrollEnabled = NO;
            textView.text = messageModel.message;
            textView.font = font;
            [cell addSubview:textView];
            [textView release];
            cell.textLabel.text = nil;
            cell.detailTextLabel.text = nil;
            
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(inbox){
        NewMessageViewController *createMessageViewController = [[NewMessageViewController alloc] init];
        createMessageViewController.title = @"New message";
        [self.navigationController pushViewController:createMessageViewController animated:YES];
        createMessageViewController.toTextField.text = messageModel.from.name;
        NSMutableString *subjectString = [[NSMutableString alloc] init];
        [subjectString appendString:@"Re: "];
        [subjectString appendString:messageModel.subject];
        createMessageViewController.subjectTextField.text = subjectString;
        [subjectString release];
        [createMessageViewController release]; 
    }else{
        NewMessageViewController *createMessageViewController = [[NewMessageViewController alloc] init];
        createMessageViewController.title = @"New message";
        [self.navigationController pushViewController:createMessageViewController animated:YES];
        UserModel *userModel = [messageModel.toUsers objectAtIndex:indexPath.row];
        createMessageViewController.toTextField.text = userModel.name;
        NSMutableString *subjectString = [[NSMutableString alloc] init];
        [subjectString appendString:@"Re: "];
        [subjectString appendString:messageModel.subject];
        createMessageViewController.subjectTextField.text = subjectString;
        [subjectString release];
        [createMessageViewController release]; 
    }
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
    if (indexPath.section == 2){
        NSString *title = messageModel.message;
        UIFont *font = [UIFont systemFontOfSize:TEXT_VIEW_FONT_SIZE];
        CGSize titleSize = {0, 0};
        titleSize = [title sizeWithFont:font
                      constrainedToSize:CGSizeMake(TEXT_VIEW_WIDTH, FLT_MAX)];
        float height = titleSize.height;
        if(height < TEXT_VIEW_HEIGHT)
            height = TEXT_VIEW_HEIGHT;
        return height + TEXT_VIEW_PADDING ;
    } else if (indexPath.section == 1){
        NSString *title = messageModel.subject;
        UIFont *font = [UIFont boldSystemFontOfSize:SUBJECT_FONT_SIZE];
        CGSize titleSize = {0, 0};
        titleSize = [title sizeWithFont:font
                      constrainedToSize:CGSizeMake(270.0f, FLT_MAX)];
        float height = titleSize.height;
        if(height < 24)
            height = 24;
        return height + 20;
    } else{
        return 44;
    }
    
    
}


@end
