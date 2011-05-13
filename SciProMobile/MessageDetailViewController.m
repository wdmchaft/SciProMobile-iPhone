//
//  MessageDetailViewController.m
//  SciProMobile
//
//  Created by Johan Aschan on 2011-04-18.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "UnreadMessageDelegate.h"
#import "LoginSingleton.h"


@implementation MessageDetailViewController
@synthesize from;
@synthesize date;
@synthesize subject;
@synthesize textView;
@synthesize scrollView;

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
    [from release];
    [date release];
    [subject release];
    [textView release];
    [scrollView release];
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
    [self setFrom:nil];
    [self setDate:nil];
    [self setSubject:nil];
    [self setTextView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getUnreadMessageNumber];
    //Do Stuff
}

- (void)getUnreadMessageNumber{
    NSMutableString *url = [NSMutableString stringWithString:@"http://localhost:8080/SciPro/json/message/unread?userid="];
    [url appendString:[[LoginSingleton instance].userid stringValue]];
	[url appendString:@"&apikey="];
    [url appendString:[LoginSingleton instance].apikey];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    UnreadMessageDelegate *unreadDelegate = [[UnreadMessageDelegate alloc]init];
    unreadDelegate.tabBarItem =  [(UIViewController *)[[self tabBarController].viewControllers objectAtIndex:1] tabBarItem];
	[[NSURLConnection alloc] initWithRequest:request delegate:unreadDelegate];
    [unreadDelegate release];
}

@end
