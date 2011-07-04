//
//  StatusReportViewController.m
//  SciProMobile
//
/*
 * Copyright (c) 2011 Johan Aschan.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "StatusReportViewController.h"
#import "JSON.h"
#import "LoginViewController.h"
#import "LoginSingleton.h"
#import "PostDelegate.h"
#import "Reachability.h"

@implementation StatusReportViewController
@synthesize availableSwitch;
@synthesize statusMessageTextField;

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
    [[NSNotificationCenter defaultCenter] removeObserver:networkObserver];
    [networkObserver release];
    [activityIndicator release];
    [statusMessageTextField release];
    [availableSwitch release];
    [super dealloc];
}

- (void)updateView{
    responseData = [[NSMutableData data] retain];
    NSMutableString *url = [[NSMutableString alloc] initWithString:[LoginSingleton getAddress]];
    [url appendString:@"json/status?userid="];
    [url appendString:[[LoginSingleton instance].user.userId stringValue]];
	[url appendString:@"&apikey="];
    [url appendString:[LoginSingleton instance].apikey];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [url release];
    NSURLConnection *conn= [[NSURLConnection alloc] initWithRequest:request delegate:self];  
    if (conn){
        [activityIndicator startAnimating];
    }
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
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.rightBarButtonItem = barButton;
    [barButton release];

    // Do any additional setup after loading the view from its nib.
}

//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    [self updatestatus];
//}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    networkObserver = [[NetworkObserver alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:networkObserver selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    [self updateView];
}
- (void)viewDidUnload
{
    [self setStatusMessageTextField:nil];
    [self setAvailableSwitch:nil];
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
    if (theTextField == statusMessageTextField) {
        [statusMessageTextField resignFirstResponder];
    } 
    return YES;
}

- (IBAction)updateStatus:(id)sender {
    [self setStatus];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {	
    [connection release];
    [responseData release];
    responseData = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
    responseData = nil;
	NSError *error;
	SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    
	NSMutableDictionary *projectDictionary = [jsonParser objectWithString:responseString error:&error];
    if (projectDictionary == nil){
	} else {
        NSString *apiCheck = [projectDictionary objectForKey:@"apikey"];
        
        if ([apiCheck isEqualToString:@"success"]){
            if([[projectDictionary objectForKey:@"status"] isEqualToNumber: [NSNumber numberWithInt:0]])
                availableSwitch.on = NO;
            else
                availableSwitch.on = YES;
            statusMessageTextField.text = [projectDictionary objectForKey:@"statusmessage"];
            
        } else{
            UIAlertView *errorAlert = [[UIAlertView alloc]
                                       initWithTitle: @"Connection problems"
                                       message: @"Connections problems, try login again."
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
            [errorAlert show];
            [errorAlert release];
            [LoginSingleton instance].user = nil;
            [LoginSingleton instance].iphoneId = nil;
            [LoginSingleton instance].apikey = nil;
            LoginViewController *lvc = [[LoginViewController alloc] init];
            lvc.delegate = [[UIApplication sharedApplication] delegate];
            [[self tabBarController] presentModalViewController:lvc animated:NO];
            [lvc release];
            
        }
        
    }
    [responseString release];	
    [jsonParser release];
    [activityIndicator stopAnimating];
}

- (void)setStatus{      
    NSMutableDictionary* jsonObject = [NSMutableDictionary dictionary];
    [jsonObject setObject:[LoginSingleton instance].user.userId forKey:@"userid"];
    [jsonObject setObject:[LoginSingleton instance].apikey forKey:@"apikey"];
    [jsonObject setObject:[NSNumber numberWithBool: availableSwitch.on] forKey:@"available"];
    NSString *status;
    if(statusMessageTextField.text == nil){
        status = @"";
    }else{
        status = statusMessageTextField.text;
    }
    [jsonObject setObject:status forKey:@"status"];
    NSString* jsonString = jsonObject.JSONRepresentation;
    NSString *requestString = [NSString stringWithFormat:@"json=%@", jsonString, nil];
    
    const char* reqString = [requestString UTF8String];
    NSInteger length = strlen(reqString);
    
    
    NSData *requestData = [NSData dataWithBytes: reqString length: length];
    
    NSMutableString *url = [[NSMutableString alloc] initWithString:[LoginSingleton getAddress]];
    [url appendString:@"json/setstatus"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: url]];
    [url release];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: requestData];
    
    PostDelegate *postDelegate= [[PostDelegate alloc]init];
    postDelegate.successAlert = YES;
    postDelegate.successMessage = @"Status succesfully updated.";
    postDelegate.successTitle = @"Status updated";
    NSURLConnection *conn= [[NSURLConnection alloc] initWithRequest:request delegate:postDelegate];  
    [postDelegate release];
}


@end
