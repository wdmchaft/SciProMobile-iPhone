//
//  StatusReportViewController.m
//  SciProMobile
//
//  Created by Johan Aschan on 2011-05-08.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import "StatusReportViewController.h"


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
    [statusMessageTextField release];
    [availableSwitch release];
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

}
@end
