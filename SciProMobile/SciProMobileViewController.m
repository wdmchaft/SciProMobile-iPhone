//
//  SciProMobileViewController.m
//  SciProMobile
//
//  Created by Johan Aschan on 2011-03-30.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import "SciProMobileViewController.h"

@implementation SciProMobileViewController
@synthesize textField;
@synthesize label;
@synthesize userName;

- (void)dealloc
{
    [userName release];
    [textField release];
    [label release];
    [label release];
    [super dealloc];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == textField) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    CGRect frame = CGRectMake(20.0, 68.0, 280.0, 31.0);
    UITextField *aTextField = [[UITextField alloc] initWithFrame:frame];
    self.textField = aTextField;
    [aTextField release];
    
    textField.textAlignment = UITextAlignmentCenter;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    
    textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = self;
    [self.view addSubview:textField];
}


- (void)viewDidUnload
{
    [self setTextField:nil];
    [self setLabel:nil];
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

- (IBAction)changeGreeting:(id)sender {
    self.userName = textField.text;
    
    NSString *nameString = self.userName;
    if ([nameString length] == 0) {
        nameString = @"World";
    }
    NSString *greeting = [[NSString alloc] initWithFormat:@"Hello, %@!", nameString];
    label.text = greeting;
    [greeting release];
}
@end
