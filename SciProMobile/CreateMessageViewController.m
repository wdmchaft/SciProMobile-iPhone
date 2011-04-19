//
//  CreateMessageViewController.m
//  SciProMobile
//
//  Created by Johan Aschan on 2011-04-07.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import "CreateMessageViewController.h"


@implementation CreateMessageViewController
@synthesize toTextField;
@synthesize subjectTextField;
@synthesize messageTextView;

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



- (IBAction)sendAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
