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
    messages = [[NSMutableArray alloc]init];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateView];
    [self getUnreadMessageNumber];
    //Do Stuff
}

- (void)updateView{
    [messages removeAllObjects];
    responseData = [[NSMutableData data] retain];
    NSMutableString *url = [NSMutableString stringWithString:@"http://localhost:8080/SciPro/json/message?userid="];
    [url appendString:[[LoginSingleton instance].userid stringValue]];
	[url appendString:@"&apikey="];
    [url appendString:[LoginSingleton instance].apikey];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}
- (void)getUnreadMessageNumber{
    NSMutableString *url = [NSMutableString stringWithString:@"http://localhost:8080/SciPro/json/message/unread?userid="];
    [url appendString:[[LoginSingleton instance].userid stringValue]];
	[url appendString:@"&apikey="];
    [url appendString:[LoginSingleton instance].apikey];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    UnreadMessageDelegate *unreadDelegate = [[UnreadMessageDelegate alloc]init];
    unreadDelegate.tabBarItem =  [(UIViewController *)[[self tabBarController].viewControllers objectAtIndex:1] tabBarItem];
	[[NSURLConnection alloc] initWithRequest:request delegate:unreadDelegate];
    [unreadDelegate release];
}


- (void) showInfoView:(id)sender
{
    NewMessageViewController *createMessageViewController = [[NewMessageViewController alloc] init];
    createMessageViewController.title = @"New message";
    [self.navigationController pushViewController:createMessageViewController animated:YES];
    [createMessageViewController release]; 
    
    
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
   
    NSNumber *number = messageModel.messageId;
    if(messageModel.read == NO){
        [self setRead: number];
        NSLog(@"%@", messageModel.messageId);
    }
    messageDetailViewController.title = messageModel.subject;
    [self.navigationController pushViewController:messageDetailViewController animated:YES];
    [messageDetailViewController.subject setText:messageModel.subject];
    [messageDetailViewController.textView setText:messageModel.message];
    NSMutableString *from = [NSMutableString stringWithString: messageModel.from.name];
    
    [messageDetailViewController.from setText:from];
    
    messageDetailViewController.date.text = messageModel.sentDate;
    [messageDetailViewController release];
    
}

- (void)setRead: (NSNumber*) recipientId{
    NSMutableDictionary* jsonObject = [NSMutableDictionary dictionary];
    [jsonObject setObject:recipientId forKey:@"id"];
    [jsonObject setObject:[LoginSingleton instance].userid forKey:@"userid"];
    [jsonObject setObject:[LoginSingleton instance].apikey forKey:@"apikey"];
    NSString* jsonString = jsonObject.JSONRepresentation;
    NSString *requestString = [NSString stringWithFormat:@"json=%@", jsonString, nil];
    
    const char* reqString = [requestString UTF8String];
    NSInteger length = strlen(reqString);
    
    
    NSData *requestData = [NSData dataWithBytes: reqString length: length];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://localhost:8080/SciPro/json/message/setread"]];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: requestData];
    
    NSError *error;
    
    NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
    NSString *responseString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    
	NSMutableDictionary *messDict = [jsonParser objectWithString:responseString error:&error];
    if (messDict == nil)

         NSLog(@"%@", [NSString stringWithFormat:@"JSON parsing failed: %@", [error localizedDescription]]);
	else {
        NSString *apiCheck = [messDict objectForKey:@"apikey"];
        if (![apiCheck isEqualToString:@"success"]) {
            
            UIAlertView *errorAlert = [[UIAlertView alloc]
                                       initWithTitle: @"Connection problems"
                                       message: @"API-key mismatched login again."
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
            [errorAlert show];
            [errorAlert release];
            LoginViewController *lvc = [[LoginViewController alloc] init];
            lvc.delegate = [[UIApplication sharedApplication] delegate];
            [[self tabBarController] presentModalViewController:lvc animated:NO];
            [lvc release];
            
            
            
        } else{
            NSLog(@"%@", @"UTFÖRT");
        }
    }
    [responseString release];	
    [jsonParser release];
    [request release];
}

- (void)deleteMessage: (NSNumber*) recipientId{
    NSMutableDictionary* jsonObject = [NSMutableDictionary dictionary];
    [jsonObject setObject:recipientId forKey:@"id"];
    [jsonObject setObject:[LoginSingleton instance].userid forKey:@"userid"];
    [jsonObject setObject:[LoginSingleton instance].apikey forKey:@"apikey"];
    NSString* jsonString = jsonObject.JSONRepresentation;
    NSString *requestString = [NSString stringWithFormat:@"json=%@", jsonString, nil];
    
    const char* reqString = [requestString UTF8String];
    NSInteger length = strlen(reqString);
    
    
    NSData *requestData = [NSData dataWithBytes: reqString length: length];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://localhost:8080/SciPro/json/message/delete"]];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: requestData];
    
    NSError *error;
    
    NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
    NSString *responseString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    
	NSMutableDictionary *messDict = [jsonParser objectWithString:responseString error:&error];
    if (messDict == nil)
        
        NSLog(@"%@", [NSString stringWithFormat:@"JSON parsing failed: %@", [error localizedDescription]]);
	else {
        NSString *apiCheck = [messDict objectForKey:@"apikey"];
        if (![apiCheck isEqualToString:@"success"]) {
            
            UIAlertView *errorAlert = [[UIAlertView alloc]
                                       initWithTitle: @"Connection problems"
                                       message: @"API-key mismatched login again."
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
            [errorAlert show];
            [errorAlert release];
            LoginViewController *lvc = [[LoginViewController alloc] init];
            lvc.delegate = [[UIApplication sharedApplication] delegate];
            [[self tabBarController] presentModalViewController:lvc animated:NO];
            [lvc release];
            
            
            
        } else{
            NSLog(@"%@", @"UTFÖRT");
        }
    }
    [responseString release];	
    [jsonParser release];
    [request release];
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
//        [messages removeObject:messageModel];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self deleteMessage: messageModel.messageId];
        [self updateView];
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
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];

	[responseData release];
    
	NSError *error;
	SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    
	NSMutableDictionary *messageDict = [jsonParser objectWithString:responseString error:&error];
    if (messageDict == nil)
		[NSString stringWithFormat:@"JSON parsing failed: %@", [error localizedDescription]];
	else {
        NSString *apiCheck = [messageDict objectForKey:@"apikey"];
        if ([apiCheck isEqualToString:@"success"]) {
            NSMutableArray *messArray = [messageDict objectForKey:@"messageArray"];
            
            for(unsigned int i = 0; i < [messArray count]; i++){
                
                NSString *message = [[messArray objectAtIndex:i] objectForKey:@"message"];
                NSString *subject = [[messArray objectAtIndex:i] objectForKey:@"subject"];
                NSString *date = [[messArray objectAtIndex:i] objectForKey:@"date"];
                NSNumber *messId = [[messArray objectAtIndex:i] objectForKey:@"id"];
                NSNumber *read = [[messArray objectAtIndex:i] objectForKey:@"read"];
                NSMutableArray *userDict = [[messArray objectAtIndex:i] objectForKey:@"from"];
                
                UserModel *userModel = [[UserModel alloc] initWithId: [userDict objectForKey:@"id"] name:[messageDict objectForKey:@"name"]];;
                
                MessageModel *messageModel = [[MessageModel alloc]initWithMessageId:messId From:userModel subject:subject message:message date:date read:[read boolValue]];
                [messages addObject:messageModel];
                [messageModel release];
                [userModel release];
            }
        	
            [[self tableView] reloadData];
        } else{
            UIAlertView *errorAlert = [[UIAlertView alloc]
                                       initWithTitle: @"Connection problems"
                                       message: @"API-key mismatched login again."
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


- (void)dealloc{   
    [messages release];
    [super dealloc];
}

@end
