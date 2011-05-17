//
//  CreateMessageViewController.m
//  SciProMobile
//
//  Created by Johan Aschan on 2011-04-07.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import "NewMessageViewController.h"
#import "SearchUserViewController.h"
#import "JSON.h"
#import "LoginSingleton.h"
#import "LoginViewController.h"
#import "UserListSingleton.h"
#import <QuartzCore/QuartzCore.h>
#import "UnreadMessageDelegate.h"
#import "PostDelegate.h"


@implementation NewMessageViewController
@synthesize toTextField;
@synthesize textView;
@synthesize subjectTextField;
@synthesize projectSend;
@synthesize projectUsers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == toTextField) {
        [toTextField resignFirstResponder];
    } else if (theTextField == subjectTextField) {
        [subjectTextField resignFirstResponder];
    } 
    return YES;
}

- (void)dealloc
{
    [subjectTextField release];
    [toTextField release];
    [textView release];
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
    UIBarButtonItem* infoButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(sendAction:)];
	self.navigationItem.rightBarButtonItem = infoButton;
    textView.layer.borderWidth = 1;
    textView.layer.borderColor = [[UIColor grayColor] CGColor];
    [subjectTextField becomeFirstResponder];
    
    [infoButton release];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setSubjectTextField:nil];
    [self setToTextField:nil];
    [self setTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (BOOL)newMessageWithSubject: (NSString*) subject andMessage:(NSString*) message andUserArray: (NSMutableArray*) toUserIdArray {
    if([subject isEqualToString:@""] || [message isEqualToString:@""] || [toUserIdArray count] == 0){
        return NO;
    }
    NSMutableDictionary* jsonObject = [NSMutableDictionary dictionary];
    [jsonObject setObject:[LoginSingleton instance].user.userId forKey:@"userid"];
    [jsonObject setObject:[LoginSingleton instance].apikey forKey:@"apikey"];
    [jsonObject setObject:subject forKey:@"subject"];
    [jsonObject setObject:message forKey:@"message"];
    [jsonObject setObject:toUserIdArray forKey:@"toUserIdArray"];
    NSString* jsonString = jsonObject.JSONRepresentation;
    NSString *requestString = [NSString stringWithFormat:@"json=%@", jsonString, nil];
    
    const char* reqString = [requestString UTF8String];
    NSInteger length = strlen(reqString);
    
    
    NSData *requestData = [NSData dataWithBytes: reqString length: length];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: @"http://130.229.156.97:8080/SciPro/json/message/newmessage"]];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: requestData];
    
    PostDelegate *postDelegate= [[PostDelegate alloc]init];
    postDelegate.successAlert = YES;
    postDelegate.successMessage = @"Message successfully sent.";
    postDelegate.successTitle = @"Message sent";
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
    return YES;
}


- (IBAction)sendAction:(id)sender {
    
    NSMutableArray *array = [UserListSingleton instance].mutableArray;
    
    NSMutableArray *userIdArray = [[NSMutableArray alloc] init];
    
    if(projectSend){
        for(unsigned int i = 0; i < [projectUsers count]; i++){
            UserModel *user = [projectUsers objectAtIndex:i];
            [userIdArray addObject:user.userId];
        }
    } else{
        for(unsigned int i = 0; i < [array count]; i++){
            UserModel *user = [array objectAtIndex:i];
            if ([user.name isEqualToString:toTextField.text]) {
                [userIdArray addObject:user.userId];
            }
        }
    }
    if(![self newMessageWithSubject: (NSString*) subjectTextField.text andMessage:(NSString*) textView.text andUserArray: (NSMutableArray*) userIdArray]){
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle: @"Missing input"
                                   message: @"To, subject or message is missing input."
                                   delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
    }else{
        [[self navigationController] popViewControllerAnimated:YES];
    }
    
    
    [userIdArray release];
}

- (IBAction)searchField:(id)sender {
    if(!projectSend){
        SearchUserViewController *searchUserViewController = [[SearchUserViewController alloc] init];
        searchUserViewController.title = @"User search";
        searchUserViewController.createMessageViewController = self;
        
        [self.navigationController pushViewController:searchUserViewController animated:YES];
        [searchUserViewController release]; 
    }
}
@end
