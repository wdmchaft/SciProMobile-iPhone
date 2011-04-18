//
//  LoginViewController.m
//  SciProMobile
//
//  Created by Johan Aschan on 2011-04-07.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import "LoginViewController.h"
#import "JSON.h"


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

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	label.text = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
    [responseData release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
    
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
    
	NSError *error;
	SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];

	NSArray *luckyNumbers = [jsonParser objectWithString:responseString error:&error];
    NSLog(@"%@", responseString);
	[responseString release];	
    
	if (luckyNumbers == nil)
		label.text = [NSString stringWithFormat:@"JSON parsing failed: %@", [error localizedDescription]];
	else {
		NSMutableString *text = [NSMutableString stringWithString:@"Lucky numbers:\n"];
        
		for (unsigned int i = 0; i < [luckyNumbers count]; i++){
			[text appendFormat:@"%@\n", [luckyNumbers objectAtIndex:i]];
            NSLog(@"%@", [luckyNumbers objectAtIndex:i]);
        }
        
		label.text =  text;
	}
    [jsonParser release];
    [jsonWriter release];
}


- (IBAction)buttonPressed:(id)sender {
    responseData = [[NSMutableData data] retain];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.unpossible.com/misc/lucky_numbers.json"]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [delegate loginViewControllerDidFinish:self];
}
@end
