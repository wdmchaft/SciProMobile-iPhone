//
//  ProjectViewController.m
//  SciProMobile
//
//  Created by Johan Aschan on 2011-04-07.
//  Copyright 2011 Stockholms universitet. All rights reserved.
//

#import "ProjectViewController.h"
#import "ProjectDetailViewController.h"
#import "JSON.h"
#import "ProjectModel.h"

@implementation ProjectViewController

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
    [projects release];
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
    responseData = [[NSMutableData data] retain];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.unpossible.com/misc/lucky_numbers.json"]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
    // Do any additional setup after loading the view from its nib.
    
    ProjectModel *firstProject = [[ProjectModel alloc] initWithTitle:@"Iphone-app" statusMessage:@"Bra"  status:GREEN];
    ProjectModel *secondProject = [[ProjectModel alloc] initWithTitle:@"Android-app" statusMessage:@"Bad data collection"  status:RED];
    ProjectModel *thirdProject = [[ProjectModel alloc] initWithTitle:@"Peer-project" statusMessage:@"Works hard and seminar on tuesdar"  status:GREEN];
    projects = [[NSMutableArray alloc]initWithObjects:firstProject, secondProject, thirdProject, nil];
    [projects sortUsingSelector:@selector(sortByStatus:)];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)projectButton:(id)sender 
{
                                                            
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[NSString stringWithFormat:@"Connection failed: %@", [error description]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
    
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
    
	NSError *error;
	SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    
	NSArray *luckyNumbers = [jsonParser objectWithString:responseString error:&error];
    NSLog(@"%@", responseString);
	[responseString release];	
    
	if (luckyNumbers == nil)
		[NSString stringWithFormat:@"JSON parsing failed: %@", [error localizedDescription]];
	else {
		NSMutableString *text = [NSMutableString stringWithString:@"Lucky numbers:\n"];
        
		for (unsigned int i = 0; i < [luckyNumbers count]; i++){
			[text appendFormat:@"%@\n", [luckyNumbers objectAtIndex:i]];
            NSLog(@"%@", [luckyNumbers objectAtIndex:i]);
        }
	}
    [jsonParser release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [projects count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.;
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier] autorelease];
    }
    ProjectModel *objectAtIndex = [projects objectAtIndex: indexPath.row];

    switch (objectAtIndex.status) {
        case RED:
            cell.imageView.image = [UIImage imageNamed:@"red_ball_small.png"];
            break;
        case GREEN:
            cell.imageView.image = [UIImage imageNamed:@"green_ball_small.png"];
            break;
        default:
            break;
    }
    cell.textLabel.text = objectAtIndex.title;
    cell.detailTextLabel.text = objectAtIndex.statusMessage;

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectDetailViewController *projectDetailViewController = [[ProjectDetailViewController alloc] init];
    projectDetailViewController.title = @"Project Details";
    [self.navigationController pushViewController:projectDetailViewController animated:YES];
    [projectDetailViewController release];   
}


@end
