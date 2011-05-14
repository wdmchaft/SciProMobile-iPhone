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
#import <CoreLocation/CLLocation.h>
#import <CoreLocation/CoreLocation.h>
#import "StatusReportViewController.h"
#import "UserModel.h"
#import "LoginSingleton.h"
#import "LoginViewController.h"
#import "UnreadMessageDelegate.h"
#import "UserListSingleton.h"

@implementation ProjectViewController
@synthesize locationManager;
@synthesize bestEffortAtLocation;

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
    [locationManager release];
    [bestEffortAtLocation release];
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
    projects = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view from its nib.
    
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    locationManager.delegate = self;
    // This is the most important property to set for the manager. It ultimately determines how the manager will
    // attempt to acquire location and thus, the amount of power that will be consumed.
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    // Once configured, the location manager must be "started".
    if([self registerRegionWithIdentifier:@"DSV"]){
        [locationManager startMonitoringSignificantLocationChanges];
    }
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateView];
    [self getUnreadMessageNumber];
    //Do Stuff
}
- (void)updateView{
    [projects removeAllObjects];
    responseData = [[NSMutableData data] retain];
    NSMutableString *url = [NSMutableString stringWithString:@"http://localhost:8080/SciPro/json/project?userid="];
    [url appendString:[[LoginSingleton instance].user.userId stringValue]];
	[url appendString:@"&apikey="];
    [url appendString:[LoginSingleton instance].apikey];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (void)getUnreadMessageNumber{
    NSMutableString *url = [NSMutableString stringWithString:@"http://localhost:8080/SciPro/json/message/unread?userid="];
    [url appendString:[[LoginSingleton instance].user.userId stringValue]];
	[url appendString:@"&apikey="];
    [url appendString:[LoginSingleton instance].apikey];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    UnreadMessageDelegate *unreadDelegate = [[UnreadMessageDelegate alloc]init];
    unreadDelegate.tabBarItem =  [(UIViewController *)[[self tabBarController].viewControllers objectAtIndex:1] tabBarItem];
	[[NSURLConnection alloc] initWithRequest:request delegate:unreadDelegate];
    NSLog(@"%@", @"test");
    [unreadDelegate release];
}

- (BOOL)registerRegionWithIdentifier:(NSString*)identifier
{
    // Do not create regions if support is unavailable or disabled.
    if ( ![CLLocationManager regionMonitoringAvailable] ||
        ![CLLocationManager regionMonitoringEnabled] )
        return NO;
    
    // If the radius is too large, registration fails automatically,
    // so clamp the radius to the max value.
    CLLocationDegrees radius = 100;
    CLLocationCoordinate2D coord;
    coord.latitude = 59.40547377;
    coord.longitude = 17.94316774;
    if (radius > self.locationManager.maximumRegionMonitoringDistance)
        radius = self.locationManager.maximumRegionMonitoringDistance;
    
    // Create the region and start monitoring it.
    CLRegion* region = [[CLRegion alloc] initCircularRegionWithCenter:coord
                                                               radius:radius identifier:identifier];
    [self.locationManager startMonitoringForRegion:region
                                   desiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    [region release];
    return YES;
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    if([region identifier] == @"DSV"){
        StatusReportViewController *statusReportViewController = [[StatusReportViewController alloc] init];
        statusReportViewController.title = @"Status Report";
        [self.navigationController pushViewController:statusReportViewController animated:YES];
        [statusReportViewController release];   
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    if([region identifier] == @"DSV"){
        StatusReportViewController *statusReportViewController = [[StatusReportViewController alloc] init];
        statusReportViewController.title = @"Status Report";
        [self.navigationController pushViewController:statusReportViewController animated:YES];
        [statusReportViewController release];   
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    // store all of the measurements, just so we can see what kind of data we might receive
    // test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    // test the measurement to see if it is more accurate than the previous measurement
    if (bestEffortAtLocation == nil || bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
        // store the location as the "best effort"
        self.bestEffortAtLocation = newLocation;
        // test the measurement to see if it meets the desired accuracy
        //
        // IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue 
        // accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of 
        // acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
        //
        if (newLocation.horizontalAccuracy <= locationManager.desiredAccuracy) {
            // we have a measurement that meets our requirements, so we can stop updating the location
            // 
            // IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
            //
            [self stopUpdatingLocation:NSLocalizedString(@"Acquired Location", @"Acquired Location")];
            // we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation:) object:nil];
        }
    }
    // update the display with the new location data
    [self.tableView reloadData];    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // The location "unknown" error simply means the manager is currently unable to get the location.
    // We can ignore this error for the scenario of getting a single location fix, because we already have a 
    // timeout that will stop the location manager to save power.
    if ([error code] != kCLErrorLocationUnknown) {
        [self stopUpdatingLocation:NSLocalizedString(@"Error", @"Error")];
    }
}

- (void)stopUpdatingLocation:(NSString *)state {
    NSLog(@"%@", state);
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
    
    UIBarButtonItem *resetItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Reset", @"Reset") style:UIBarButtonItemStyleBordered target:self action:@selector(reset)] autorelease];
    [self.navigationItem setLeftBarButtonItem:resetItem animated:YES];;
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
    NSLog(@"%@", responseString);
	[responseData release];
    
	NSError *error;
	SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    
	NSMutableDictionary *projectDictionary = [jsonParser objectWithString:responseString error:&error];
    if (projectDictionary == nil){
		[NSString stringWithFormat:@"JSON parsing failed: %@", [error localizedDescription]];
    } else {
        NSString *apiCheck = [projectDictionary objectForKey:@"apikey"];
        if ([apiCheck isEqualToString:@"success"]) {
            
            NSMutableArray *projectDict = [projectDictionary objectForKey:@"projectArray"];
            NSMutableArray *allUsers = [[NSMutableArray alloc] init];
            for(unsigned int i = 0; i < [projectDict count]; i++){
                
                Status status;
                NSString *statusString = [[projectDict objectAtIndex:i] objectForKey:@"status"];
                if ( statusString == @"NEEDHELP") {
                    status = NEEDHELP;
                } else if(statusString == @"FINE"){
                    status = FINE;
                } else{
                    status = NEUTRAL;
                }
                NSMutableArray *projectMembers = [[projectDict objectAtIndex:i] objectForKey:@"projectMembers"];
                NSMutableArray *projectReviewers = [[projectDict objectAtIndex:i] objectForKey:@"projectReviewers"];
                NSMutableArray *projectCosupervisors = [[projectDict objectAtIndex:i] objectForKey:@"projectCosupervisors"];
                NSMutableArray *members = [[NSMutableArray alloc] init];
                NSMutableArray *reviewers = [[NSMutableArray alloc] init];
                NSMutableArray *coSupervisors = [[NSMutableArray alloc] init];
                
                for(unsigned int i = 0; i < [projectMembers count]; i++){
                    UserModel *userModel = [[UserModel alloc] initWithId:[[projectMembers objectAtIndex:i] objectForKey:@"id"] name:[[projectMembers objectAtIndex:i] objectForKey:@"name"]];
                    [members addObject: userModel];
                    [allUsers addObject:userModel];
                    [userModel release];
                }
                for(unsigned int i = 0; i < [projectReviewers count]; i++){
                    UserModel *userModel = [[UserModel alloc] initWithId:[[projectReviewers objectAtIndex:i] objectForKey:@"id"] name:[[projectReviewers objectAtIndex:i] objectForKey:@"name"]];
                    
                    [reviewers addObject: userModel];
                    [allUsers addObject:userModel];
                    [userModel release];
                }
                for(unsigned int i = 0; i < [projectCosupervisors count]; i++){
                    UserModel *userModel = [[UserModel alloc] initWithId:[[projectCosupervisors objectAtIndex:i] objectForKey:@"id"] name:[[projectCosupervisors objectAtIndex:i] objectForKey:@"name"]];
                    [coSupervisors addObject: userModel];
                    [allUsers addObject:userModel];
                    [userModel release];
                }
                
                [UserListSingleton instance].mutableArray = allUsers;
                
                ProjectModel *projectModel = [[ProjectModel alloc] initWithTitle:[[projectDict objectAtIndex:i] objectForKey:@"title"] statusMessage:[[projectDict objectAtIndex:i] objectForKey:@"statusMessage"]  status:status members:members level:[[projectDict objectAtIndex:i] objectForKey:@"level"] reviewer:reviewers coSupervisors:coSupervisors];
                [projects addObject:projectModel];
                [projectModel release];
                [members release];
                [reviewers release];
                [coSupervisors release];
                
            }
            [allUsers addObject: [LoginSingleton instance].user];
            [allUsers release];
            
            [projects sortUsingSelector:@selector(sortByStatus:)];
            
            
            
            [[self tableView] reloadData];
            
            
            
            
        } else{
            UIAlertView *errorAlert = [[UIAlertView alloc]
                                       initWithTitle: @"Connection problems"
                                       message: @"API-key mismatched login again."
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
            [errorAlert show];
            [errorAlert release];
            LoginViewController *lvc = [[LoginViewController alloc] init];
            lvc.delegate = [[UIApplication sharedApplication] delegate];
            [[self tabBarController] presentModalViewController:lvc animated:NO];
            [lvc release];
        }
    }
    [responseString release];	
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
        case NEEDHELP:
            cell.imageView.image = [UIImage imageNamed:@"red_ball_small.png"];
            break;
        case FINE:
            cell.imageView.image = [UIImage imageNamed:@"green_ball_small.png"];
            break;
        default:
            cell.imageView.image = [UIImage imageNamed:@"yellow_ball_small.png"];
            break;
    }
    cell.textLabel.text = objectAtIndex.title;
    cell.detailTextLabel.text = objectAtIndex.statusMessage;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectModel *projectModel = [projects objectAtIndex: indexPath.row];
    ProjectDetailViewController *projectDetailViewController = [[ProjectDetailViewController alloc] init];
    [self.navigationController pushViewController:projectDetailViewController animated:YES];
    projectDetailViewController.title = @"Project Details";
    projectDetailViewController.projectModel = projectModel;
       
    [projectDetailViewController release];   
}


@end
