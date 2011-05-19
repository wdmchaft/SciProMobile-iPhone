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
#import "SFHFKeychainUtils.h"

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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL save = [defaults boolForKey:@"password"];
    NSString *username = [defaults stringForKey:@"username"];
    if(save){
        

        if(username != nil){ 
            NSString *password = [SFHFKeychainUtils getPasswordForUsername:username andServiceName:@"SciproMobile" error:nil];
            usernameTextField.text = username;
            if(password != nil){
                passwordTextField.text = password;
            }
            
        }
    }else{
        [defaults setValue:nil forKey:@"username"];
        [defaults synchronize];
        [SFHFKeychainUtils deleteItemForUsername:username andServiceName:@"SciproMobile" error:nil];
    };
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


- (void)loginWithUserName:(NSString*)userName password:(NSString*)password{
    
    NSMutableDictionary* jsonObject = [NSMutableDictionary dictionary];
    [jsonObject setObject:userName forKey:@"username"];
    [jsonObject setObject:password forKey:@"password"];
    NSString *iphoneId;
    if([LoginSingleton instance].iphoneId == nil){
        iphoneId = @"";
    }else
        iphoneId = [LoginSingleton instance].iphoneId;
    [jsonObject setObject:iphoneId forKey:@"iPhoneId"];
    NSString* jsonString = jsonObject.JSONRepresentation;
    NSString *requestString = [NSString stringWithFormat:@"json=%@", jsonString, nil];
    
    const char* reqString = [requestString UTF8String];
    NSInteger length = strlen(reqString);
    
    NSData *requestData = [NSData dataWithBytes: reqString length: length];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:8080/SciPro/json/login"]]; 
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: requestData];
    
    NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];  
    if (!conn){
        
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle: @"Connection problems"
                                   message: @"Connection problems, try login again."
                                   delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
        
    }
}

- (IBAction)buttonPressed:(id)sender {
    //responseData = [[NSMutableData data] retain];
    //[self loginWithUserName: usernameTextField.text password: passwordTextField.text]; 
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if([defaults boolForKey:@"password"]){
        [defaults setValue:usernameTextField.text forKey:@"username"];
        [defaults synchronize];
        [SFHFKeychainUtils storeUsername:usernameTextField.text andPassword:passwordTextField.text forServiceName:@"SciproMobile" updateExisting:YES error:nil];
    }
    //Teskod
    UserModel *userModel = [[UserModel alloc] initWithId:[NSNumber numberWithInt: 12] name:@"Danny Brash"];
    [LoginSingleton instance].apikey = @"pelle";
    [LoginSingleton instance].user = userModel;
    [userModel release];
    
    [delegate loginViewControllerDidFinish:self];
    
    
    
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
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
    responseData = nil;
    NSError* error;
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    
	NSMutableDictionary *messDict = [jsonParser objectWithString:responseString error:&error];
    if (messDict == nil){
        
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle: @"Connection problems"
                                   message: @"Connections problems, try login again."
                                   delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
	}else {
        NSNumber *loggedIn = [messDict objectForKey:@"authenticated"];
        if([loggedIn isEqualToNumber: [NSNumber numberWithInt:1]] ) {
            NSString *apiKey = [messDict objectForKey:@"apikey"];

            NSNumber *userId = [messDict objectForKey:@"userid"];
            NSString *name = [messDict objectForKey:@"name"];
            UserModel *userModel = [[UserModel alloc] initWithId:userId name:name];
            [LoginSingleton instance].apikey = apiKey;
            [LoginSingleton instance].user = userModel;
            [userModel release];
            [delegate loginViewControllerDidFinish:self];
            
        }
        else {
            UIAlertView *errorAlert = [[UIAlertView alloc]
                                       initWithTitle: @"Login failed"
                                       message: @"Username or password incorrect."
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
            [errorAlert show];
            [errorAlert release];
        } 
    }
    [responseString release];	
    [jsonParser release];   
}

@end
