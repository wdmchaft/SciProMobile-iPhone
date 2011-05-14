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


@implementation NewMessageViewController
@synthesize toTextField;
@synthesize subjectTextField;
@synthesize projectSend;
@synthesize messageTextView;
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
    [messageTextView release];
    [toTextField release];
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
    [self setSubjectTextField:nil];
    [self setMessageTextView:nil];
    [self setToTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])		
    {
        [textView resignFirstResponder];
        return NO;						
    }
    return YES;
}

- (BOOL)newMessageWithSubject: (NSString*) subject andMessage:(NSString*) message andUserArray: (NSMutableArray*) toUserIdArray {
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
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://localhost:8080/SciPro/json/message/newmessage"]];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: requestData];
    
    NSError *error;
    
    NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
    NSString *responseString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    
    BOOL returnValue = NO;
	NSMutableDictionary *messDict = [jsonParser objectWithString:responseString error:&error];
    if (messDict == nil){
        
        NSLog(@"%@", [NSString stringWithFormat:@"JSON parsing failed: %@", [error localizedDescription]]);
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle: @"Connection problems"
                                   message: @"Connections problems try again."
                                   delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
    }
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
            returnValue = YES;
        }
    }
    [responseString release];	
    [jsonParser release];
    [request release];
    return returnValue;
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
    if([self newMessageWithSubject: (NSString*) subjectTextField.text andMessage:(NSString*) messageTextView.text andUserArray: (NSMutableArray*) userIdArray]){
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    [userIdArray release];
}

- (IBAction)searchField:(id)sender {
    SearchUserViewController *searchUserViewController = [[SearchUserViewController alloc] init];
    searchUserViewController.title = @"User search";
    searchUserViewController.createMessageViewController = self;
    searchUserViewController.savedSearchTerm = toTextField.text;
    [self.navigationController pushViewController:searchUserViewController animated:YES];
    [searchUserViewController release]; 
}
@end
