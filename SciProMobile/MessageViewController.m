//
//  MessageViewController.m
//  SciProMobile
//
//  Created by Johan Aschan on 2011-04-07.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import "MessageViewController.h"
#import "NewMessageViewController.h"
#import "MessageModel.h"
#import "MessageDetailViewController.h"
#import "ProjectModel.h"
#import "SearchUserViewController.h"
#import "JSON.h"
#import "UserModel.h"
#import "LoginViewController.h"
#import "LoginSingleton.h"
#import "UnreadMessageDelegate.h"
#import "PostDelegate.h"

@implementation MessageViewController

@synthesize inbox;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        inbox = YES;
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
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(newMessage)];
    
    
    // create a toolbar to have two buttons in the right
    if(inbox){
        
        
        UIToolbar* tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 133, 44.01)];
        
        // create the array to hold the buttons, which then gets added to the toolbar
        NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
        
        
        
        // create a standard "refresh" button
        UIBarButtonItem* bi = [[UIBarButtonItem alloc] initWithTitle:@"Sent" style:UIBarButtonItemStyleBordered target:self action:@selector(sent)];
        [buttons addObject:bi];
        [bi release];
        
        // create a spacer
        bi = [[UIBarButtonItem alloc]
              initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [buttons addObject:bi];
        [bi release];
        
        bi = self.editButtonItem;
        [buttons addObject:bi];
        [bi release];

        
        // stick the buttons in the toolbar
        [tools setItems:buttons animated:NO];
        
        [buttons release];
        
        // and put the toolbar in the nav bar
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tools];
        [tools release];
    }else{
        UIToolbar* tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 133, 44.01)];
        
        // create the array to hold the buttons, which then gets added to the toolbar
        NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:3];
        
        // create a standard "add" button
 
         
        
        // create a standard "refresh" button
        UIBarButtonItem* bi = [[UIBarButtonItem alloc] initWithTitle:@"Inbox" style:UIBarButtonItemStyleBordered target:self action:@selector(inboxView)];
        [buttons addObject:bi];
        [bi release];
        
        
        // create a spacer
        bi = [[UIBarButtonItem alloc]
              initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        [buttons addObject:bi];
        [bi release];
        
        bi = self.editButtonItem;
        [buttons addObject:bi];
        [bi release];
        // stick the buttons in the toolbar
        [tools setItems:buttons animated:NO];
        
        [buttons release];
        
        // and put the toolbar in the nav bar
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tools];
        [tools release];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)inboxView{
    [self.navigationController popViewControllerAnimated: NO];
}

- (void)sent{
    MessageViewController *messageViewController = [[MessageViewController alloc] init];
    messageViewController.inbox = NO;
    messageViewController.title = @"Sent";
    [self.navigationController pushViewController:messageViewController animated:NO];
    [messageViewController release];  
}

- (void)newMessage{
    NewMessageViewController *messageViewController = [[NewMessageViewController alloc] init];
    messageViewController.title = @"New Message";
    [self.navigationController pushViewController:messageViewController animated:YES];
    
    [messageViewController release];  
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateView];
    //Do Stuff
}



- (void)updateView{
    
    if(!messages)
        messages = [[NSMutableArray alloc]init];
    
    
    NSMutableString *urlBasic;
    if (inbox) {
        urlBasic = [NSMutableString stringWithString: @"http://130.229.156.97:8080/SciPro/json/message?userid="];
    }else
        urlBasic = [NSMutableString stringWithString: @"http://130.229.156.97:8080/SciPro/json/message/sentmessages?userid="];
    
    NSMutableString *url = [NSMutableString stringWithString:urlBasic];
    [url appendString:[[LoginSingleton instance].user.userId stringValue]];
	[url appendString:@"&apikey="];
    [url appendString:[LoginSingleton instance].apikey];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLConnection *conn= [[NSURLConnection alloc] initWithRequest:request delegate:self];  
    if (conn){
        responseData = [[NSMutableData data] retain];
    }else{
        
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle: @"Connection problems"
                                   message: @"Connection problems, try login again."
                                   delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
        LoginViewController *lvc = [[LoginViewController alloc] init];
        lvc.delegate = [[UIApplication sharedApplication] delegate];
        [[self tabBarController] presentModalViewController:lvc animated:NO];
        [lvc release];
    } 
    [self unreadMessages];

}

- (void)unreadMessages{
    NSMutableString *url = [NSMutableString stringWithString:@"http://130.229.156.97:8080/SciPro/json/message/unread?userid="];
    [url appendString:[[LoginSingleton instance].user.userId stringValue]];
	[url appendString:@"&apikey="];
    [url appendString:[LoginSingleton instance].apikey];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    UnreadMessageDelegate *unreadDelegate = [[UnreadMessageDelegate alloc]init];
    unreadDelegate.tabBarItem =  [(UIViewController *)[[self tabBarController ].viewControllers objectAtIndex:1] tabBarItem];
    NSURLConnection *conn= [[NSURLConnection alloc] initWithRequest:request delegate:unreadDelegate];  
    if (!conn){
        
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle: @"Connection problems"
                                   message: @"Connection problems, try login again."
                                   delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
        LoginViewController *lvc = [[LoginViewController alloc] init];
        lvc.delegate = [[UIApplication sharedApplication] delegate];
        [[self tabBarController] presentModalViewController:lvc animated:NO];
        [lvc release];
    } 
    [unreadDelegate release];
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
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier] autorelease];
    }
    
    MessageModel *messageModel = [messages objectAtIndex:[indexPath row]];
    NSMutableString *string = [[NSMutableString alloc] init];
    if(inbox){
        if(!messageModel.read){
            cell.imageView.image = [UIImage imageNamed:@"blue-circle3.png"];
        } else{
            cell.imageView.image = nil;
        }
        [string appendString: messageModel.from.name];
    }else{
        BOOL first = YES;
        for(unsigned int i = 0; i < [messageModel.toUsers count]; i++){
            UserModel *userModel = [messageModel.toUsers objectAtIndex: i];
            if(first){
                [string appendString:userModel.name];
                first = NO;
            }else{
                [string appendString:@", "];
                [string appendString:userModel.name];
            }
        }
    }
    
    
    [string appendString: @"\n"];
    [string appendString: messageModel.sentDate];
    [string appendString: @"\n"];
    [string appendString: messageModel.message];
    
    cell.textLabel.text = messageModel.subject;
    cell.detailTextLabel.text = string;
    [string release];
    cell.detailTextLabel.numberOfLines = 3;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel *messageModel = [messages objectAtIndex:indexPath.row];
    MessageDetailViewController *messageDetailViewController = [[MessageDetailViewController alloc] init];
    
    NSNumber *number = messageModel.messageId;
    if(messageModel.read == NO){
        [self setRead: number];
    }

    messageDetailViewController.inbox = inbox;
   
    messageDetailViewController.title = @"Message Details";
    messageDetailViewController.messageModel = messageModel;
    [self.navigationController pushViewController:messageDetailViewController animated:YES];
    
    [messageDetailViewController release];
    
}

- (void)setRead: (NSNumber*) recipientId{
    NSMutableDictionary* jsonObject = [NSMutableDictionary dictionary];
    [jsonObject setObject:recipientId forKey:@"id"];
    [jsonObject setObject:[LoginSingleton instance].user.userId forKey:@"userid"];
    [jsonObject setObject:[LoginSingleton instance].apikey forKey:@"apikey"];
    NSString* jsonString = jsonObject.JSONRepresentation;
    NSString *requestString = [NSString stringWithFormat:@"json=%@", jsonString, nil];
    
    const char* reqString = [requestString UTF8String];
    NSInteger length = strlen(reqString);
    
    
    NSData *requestData = [NSData dataWithBytes: reqString length: length];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: @"http://130.229.156.97:8080/SciPro/json/message/setread"]];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: requestData];
    
    PostDelegate *postDelegate= [[PostDelegate alloc]init];
    postDelegate.message = YES;
    postDelegate.messageViewController = self;
    
    NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:request delegate:postDelegate];  
    [postDelegate release];
    if (!conn){
        
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle: @"Connection problems"
                                   message: @"Connection problems, try login again."
                                   delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
        LoginViewController *lvc = [[LoginViewController alloc] init];
        lvc.delegate = [[UIApplication sharedApplication] delegate];
        [[self tabBarController] presentModalViewController:lvc animated:NO];
        [lvc release];
    }  
    
    
}

- (void)deleteMessage: (NSNumber*) recipientId{
    NSMutableDictionary* jsonObject = [NSMutableDictionary dictionary];
    [jsonObject setObject:recipientId forKey:@"id"];
    [jsonObject setObject:[LoginSingleton instance].user.userId forKey:@"userid"];
    [jsonObject setObject:[LoginSingleton instance].apikey forKey:@"apikey"];
    NSString* jsonString = jsonObject.JSONRepresentation;
    NSString *requestString = [NSString stringWithFormat:@"json=%@", jsonString, nil];
    
    const char* reqString = [requestString UTF8String];
    NSInteger length = strlen(reqString);
    
    
    NSData *requestData = [NSData dataWithBytes: reqString length: length];
    NSMutableString *urlBasic;
    if (inbox) {
        urlBasic = [NSMutableString stringWithString: @"http://130.229.156.97:8080/SciPro/json/message/deleterecipient"];
    }else
        urlBasic = [NSMutableString stringWithString: @"http://130.229.156.97:8080/SciPro/json/message/deleteprivatemessage"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: urlBasic]];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: requestData];
    
    PostDelegate *postDelegate= [[PostDelegate alloc]init];
    postDelegate.message = YES;
    postDelegate.messageViewController = self;
    
    NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:request delegate:postDelegate];  
    [postDelegate release];
    if (!conn){
        
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle: @"Connection problems"
                                   message: @"Connection problems, try login again."
                                   delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
        LoginViewController *lvc = [[LoginViewController alloc] init];
        lvc.delegate = [[UIApplication sharedApplication] delegate];
        [[self tabBarController] presentModalViewController:lvc animated:NO];
        [lvc release];
    }  
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
        
        [self deleteMessage: messageModel.messageId];
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
        [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [NSString stringWithFormat:@"Connection failed: %@", [error description]];
    [connection release];
    [responseData release];
    responseData = nil;
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle: @"Connection problems"
                               message: @"Connections problems, try login again."
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
    [errorAlert show];
    [errorAlert release];
    LoginViewController *lvc = [[LoginViewController alloc] init];
    lvc.delegate = [[UIApplication sharedApplication] delegate];
    [[self tabBarController] presentModalViewController:lvc animated:NO];
    [lvc release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
	[responseData release];
    responseData = nil;
    
	NSError *error;
	SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    
	NSMutableDictionary *messageDict = [jsonParser objectWithString:responseString error:&error];
    if (messageDict == nil)
		[NSString stringWithFormat:@"JSON parsing failed: %@", [error localizedDescription]];
	else {
        NSString *apiCheck = [messageDict objectForKey:@"apikey"];
        if ([apiCheck isEqualToString:@"success"]) {
            [messages removeAllObjects];
            NSMutableArray *messArray = [messageDict objectForKey:@"messageArray"];
            
            for(unsigned int i = 0; i < [messArray count]; i++){
                
                NSString *message = [[messArray objectAtIndex:i] objectForKey:@"message"];
                NSString *subject = [[messArray objectAtIndex:i] objectForKey:@"subject"];
                NSString *date = [[messArray objectAtIndex:i] objectForKey:@"date"];
                NSNumber *messId = [[messArray objectAtIndex:i] objectForKey:@"id"];
                
                
                
                if(inbox){
                    NSNumber *read = [[messArray objectAtIndex:i] objectForKey:@"read"];
                    NSMutableDictionary *userDict = [[messArray objectAtIndex:i] objectForKey:@"from"];
                    
                    UserModel *userModel = [[UserModel alloc] initWithId: [userDict objectForKey:@"id"] name:[userDict objectForKey:@"name"]];
                    MessageModel *messageModel = [[MessageModel alloc]initWithMessageId:messId From:userModel subject:subject message:message date:date read:[read boolValue] toUsers:nil];
                    [messages addObject:messageModel];
                    
                    [messageModel release];
                    [userModel release];
                } else{
                    NSMutableArray *userArray = [[messArray objectAtIndex:i] objectForKey:@"toUsers"];
                    NSMutableArray *toUserArray = [[NSMutableArray alloc] init];
                    for(unsigned int i = 0;i < [userArray count]; i++){
                        UserModel *userModel = [[UserModel alloc] initWithId: [[userArray objectAtIndex:i] objectForKey:@"id"] name:[[userArray objectAtIndex:i] objectForKey:@"name"]];
                        [toUserArray addObject:userModel];
                        [userModel release];
                    }
                    
                    MessageModel *messageModel = [[MessageModel alloc]initWithMessageId:messId From:[LoginSingleton instance].user subject:subject message:message date:date read:NO toUsers:toUserArray];
                    [toUserArray release];
                    [messages addObject:messageModel];
                    
                    [messageModel release];
                    
                }
                
            }
        	
            [[self tableView] reloadData];
        } else{
            UIAlertView *errorAlert = [[UIAlertView alloc]
                                       initWithTitle: @"Connection problems"
                                       message: @"Connections problems, try login again."
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
            [errorAlert show];
            [errorAlert release];
            LoginViewController *lvc = [[LoginViewController alloc] init];
            lvc.delegate = [[UIApplication sharedApplication] delegate];
            [[self tabBarController] presentModalViewController:lvc animated:NO];
            [lvc release];
        }
        
	}
    [responseString release];
    [jsonParser release];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
    
}

- (void)dealloc{   
    [messages release];
    [super dealloc];
}



@end
