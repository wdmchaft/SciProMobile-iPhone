//
//  LoginViewController.m
//  SciProMobile
//
//  Created by Johan Aschan on 2011-04-07.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import "LoginViewController.h"
#import "JSON.h"
#import "LoginSingleton.h"

@implementation LoginViewController
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize label;
@synthesize delegate;

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
    [usernameTextField release];
    [passwordTextField release];
    [label release];
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
    [self setUsernameTextField:nil];
    [self setPasswordTextField:nil];
    [self setLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == usernameTextField) {
        [usernameTextField resignFirstResponder];
    } else if (theTextField == passwordTextField) {
        [passwordTextField resignFirstResponder];
    }
    return YES;
}


- (BOOL)loginWithUserName:(NSString*)userName password:(NSString*)password{
    NSMutableDictionary* jsonObject = [NSMutableDictionary dictionary];
    [jsonObject setObject:userName forKey:@"username"];
    [jsonObject setObject:password forKey:@"password"];
    NSString* jsonString = jsonObject.JSONRepresentation;
    NSString *requestString = [NSString stringWithFormat:@"json=%@", jsonString, nil];
    
    const char* reqString = [requestString UTF8String];
    NSInteger length = strlen(reqString);

    
    NSData *requestData = [NSData dataWithBytes: reqString length: length];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://localhost:8080/SciPro/json/login"]];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: requestData];
    
    NSError *error;
    
    NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
    NSString *responseString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", responseString);
	[responseData release];
    
	SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    
    BOOL returnValue = NO;
    NSLog(@"%d", returnValue);
    
	NSMutableDictionary *authenticationDict = [jsonParser objectWithString:responseString error:&error];
    if (authenticationDict == nil){
		[NSString stringWithFormat:@"JSON parsing failed: %@", [error localizedDescription]];

    } else {
        NSLog(@"%@", authenticationDict);
        NSNumber *loggedIn = [authenticationDict objectForKey:@"authenticated"];
        NSLog(@"%@", loggedIn);
        if([loggedIn isEqualToNumber: [NSNumber numberWithInt:1]] ) {
            NSString *apiKey = [authenticationDict objectForKey:@"apikey"];
            NSNumber *userId = [authenticationDict objectForKey:@"userid"];
            [LoginSingleton instance].apikey = apiKey;
            [LoginSingleton instance].userid = userId;
            returnValue = YES;
        }
	}
    [responseString release];	
    [jsonParser release];
    [request release];
    NSLog(@"%d", returnValue);
    return returnValue;
    
}
- (IBAction)buttonPressed:(id)sender {
    BOOL check = [self loginWithUserName: usernameTextField.text password: passwordTextField.text];
    NSLog(@"%d", check);
    if(check){
        [delegate loginViewControllerDidFinish:self];
    } else{
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle: @"Login failed"
                                   message: @"Username or password incorrect"
                                   delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
    }
 
}
@end
