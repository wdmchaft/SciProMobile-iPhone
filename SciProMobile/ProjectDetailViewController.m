//
//  ProjectDetailViewController.m
//  SciProMobile
//
//  Created by Johan Aschan on 2011-04-07.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import "ProjectDetailViewController.h"


@implementation ProjectDetailViewController
@synthesize statusMessage;
@synthesize projectTitle;
@synthesize members;
@synthesize level;
@synthesize statusImage;
@synthesize reviewer;
@synthesize coSupervisors;

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
    [projectTitle release];
    [members release];
    [level release];
    [statusMessage release];
    [statusImage release];
    [reviewer release];
    [coSupervisors release];
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
    [self setProjectTitle:nil];
    [self setMembers:nil];
    [self setLevel:nil];
    [self setStatusMessage:nil];
    [self setStatusImage:nil];
    [self setReviewer:nil];
    [self setCoSupervisors:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)messageToProject:(id)sender {
}
@end
