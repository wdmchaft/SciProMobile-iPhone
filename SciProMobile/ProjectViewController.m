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
#import "FinalSeminarModel.h"
#import "PostDelegate.h"

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
    
    // Do any additional setup after loading the view from its nib.
    
    self.locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    // This is the most important property to set for the manager. It ultimately determines how the manager will
    // attempt to acquire location and thus, the amount of power that will be consumed.
    // Once configured, the location manager must be "started".
    if([self registerRegionWithIdentifier:@"DSV"]){
    }
    
    UIBarButtonItem *bi = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)];
    self.navigationItem.leftBarButtonItem = bi;
}

- (void)logout{
    LoginViewController *lvc = [[LoginViewController alloc] init];
    lvc.delegate = [[UIApplication sharedApplication] delegate];
    [[self tabBarController] presentModalViewController:lvc animated:NO];
    [lvc release];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!projects){
        projects = [[NSMutableArray alloc]init];
    }
    
    [self updateView];
    
}
- (void)updateView{
    
    responseData = [[NSMutableData data] retain];
    NSMutableString *url = [NSMutableString stringWithString:@"http://192.168.0.12:8080/SciPro/json/project?userid="];
    [url appendString:[[LoginSingleton instance].user.userId stringValue]];
	[url appendString:@"&apikey="];
    [url appendString:[LoginSingleton instance].apikey];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLConnection *conn= [[NSURLConnection alloc] initWithRequest:request delegate:self];  
    if (!conn){
        
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle: @"Connection problems"
                                   message: @"Connection problems, try login again."
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
    [self getUnreadMessageNumber];
    
}

- (void)getUnreadMessageNumber{
    NSMutableString *url = [NSMutableString stringWithString:@"http://192.168.0.12:8080/SciPro/json/message/unread?userid="];
    [url appendString:[[LoginSingleton instance].user.userId stringValue]];
	[url appendString:@"&apikey="];
    [url appendString:[LoginSingleton instance].apikey];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    UnreadMessageDelegate *unreadDelegate = [[UnreadMessageDelegate alloc]init];
    unreadDelegate.tabBarItem =  [(UIViewController *)[[self tabBarController].viewControllers objectAtIndex:1] tabBarItem];
    NSURLConnection *conn= [[NSURLConnection alloc] initWithRequest:request delegate:unreadDelegate];  
    [unreadDelegate release];
    if (!conn){
        
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle: @"Connection problems"
                                   message: @"Connection problems, try login again."
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

- (BOOL)registerRegionWithIdentifier:(NSString*)identifier
{
    // Do not create regions if support is unavailable or disabled.
    if ( ![CLLocationManager regionMonitoringAvailable] ||
        ![CLLocationManager regionMonitoringEnabled] )
        return NO;
    
    // If the radius is too large, registration fails automatically,
    // so clamp the radius to the max value.
    CLLocationDegrees radius = 300;
    if (radius > self.locationManager.maximumRegionMonitoringDistance)
        radius = self.locationManager.maximumRegionMonitoringDistance;
    
    CLLocationCoordinate2D coord;
    coord.latitude = 59.40547377;
    coord.longitude = 17.94316774;
    // Create the region and start monitoring it.
    CLRegion* region = [[CLRegion alloc] initCircularRegionWithCenter:coord
                                                               radius:radius identifier:identifier];
    [self.locationManager startMonitoringForRegion:region
                                   desiredAccuracy:kCLLocationAccuracyThreeKilometers];
    
    [region release];
    return YES;
}

- (void)setStatus: (BOOL) statusBool{      
    NSMutableDictionary* jsonObject = [NSMutableDictionary dictionary];
    [jsonObject setObject:[LoginSingleton instance].user.userId forKey:@"userid"];
    [jsonObject setObject:[LoginSingleton instance].apikey forKey:@"apikey"];
    [jsonObject setObject:[NSNumber numberWithBool: statusBool] forKey:@"available"];
    [jsonObject setObject:@"Automatically registered." forKey:@"status"];
    NSString* jsonString = jsonObject.JSONRepresentation;
    NSString *requestString = [NSString stringWithFormat:@"json=%@", jsonString, nil];
    
    const char* reqString = [requestString UTF8String];
    NSInteger length = strlen(reqString);
    
    
    NSData *requestData = [NSData dataWithBytes: reqString length: length];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: @"http://192.168.0.12:8080/SciPro/json/setstatus"]];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: requestData];
    
    PostDelegate *postDelegate= [[PostDelegate alloc]init];
    NSURLConnection *conn= [[NSURLConnection alloc] initWithRequest:request delegate:postDelegate];  
    [postDelegate release];
    
    if (!conn){
        
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle: @"Connection problems"
                                   message: @"Connection problems, try login again."
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

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    if([region identifier] == @"DSV"){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        BOOL save = [defaults boolForKey:@"autoStatus"];
        
        if(save){
            [self setStatus:YES];
        } else{
            UIAlertView *errorAlert = [[UIAlertView alloc]
                                       initWithTitle: @"At DSV"
                                       message: @"Update your status so students can see if you are available."
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
            [errorAlert show];
            [errorAlert release];;   
            
        }
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL save = [defaults boolForKey:@"autoStatus"];
    
    if(save){
        [self setStatus:NO];
    } else{
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle: @"At DSV"
                                   message: @"Update your status so students can see if you are available."
                                   delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];;   
        
    }
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
    LoginViewController *lvc = [[LoginViewController alloc] init];
    lvc.delegate = [[UIApplication sharedApplication] delegate];
    [[self tabBarController] presentModalViewController:lvc animated:NO];
    [lvc release];
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
        [NSString stringWithFormat:@"JSON parsing failed: %@", [error localizedDescription]];
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle: @"Connection problems"
                                   message: @"Connections problems, try login again."
                                   delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
        LoginViewController *lvc = [[LoginViewController alloc] init];
        lvc.delegate = [[UIApplication sharedApplication] delegate];
        [[self tabBarController] presentModalViewController:lvc animated:NO];
        [lvc release];
    } else {
        NSString *apiCheck = [projectDictionary objectForKey:@"apikey"];
        if ([apiCheck isEqualToString:@"success"]) {
            [projects removeAllObjects];
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
                NSMutableArray *projectFinalseminar = [[projectDict objectAtIndex:i] objectForKey:@"finalSeminars"];
                
                NSMutableArray *members = [[NSMutableArray alloc] init];
                NSMutableArray *reviewers = [[NSMutableArray alloc] init];
                NSMutableArray *coSupervisors = [[NSMutableArray alloc] init];
                NSMutableArray *finalSeminars = [[NSMutableArray alloc] init];
                
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
                
                for(unsigned int i = 0; i < [projectFinalseminar count]; i++){
                    NSMutableArray *activeParticipants = [[projectFinalseminar objectAtIndex:i] objectForKey:@"active"];
                    NSMutableArray *opponents = [[projectFinalseminar objectAtIndex:i] objectForKey:@"opponents"];
                    
                    NSMutableArray *oppo = [[NSMutableArray alloc] init];
                    NSMutableArray *active = [[NSMutableArray alloc] init];
                    
                    for(unsigned int i = 0; i < [activeParticipants count]; i++){
                        UserModel *userModel = [[UserModel alloc] initWithId:[[activeParticipants objectAtIndex:i] objectForKey:@"id"] name:[[activeParticipants objectAtIndex:i] objectForKey:@"name"]];
                        [active addObject: userModel];
                        [allUsers addObject:userModel];
                        [userModel release];
                    }
                    
                    for(unsigned int i = 0; i < [opponents count]; i++){
                        UserModel *userModel = [[UserModel alloc] initWithId:[[opponents objectAtIndex:i] objectForKey:@"id"] name:[[opponents objectAtIndex:i] objectForKey:@"name"]];
                        [oppo addObject: userModel];
                        [allUsers addObject:userModel];
                        [userModel release];
                    }
                    
                    FinalSeminarModel *finalSeminarModel = [[FinalSeminarModel alloc] initWithRoom:[[projectFinalseminar objectAtIndex:i] objectForKey:@"room"] date:[[projectFinalseminar objectAtIndex:i] objectForKey:@"date"]opponents:oppo activeListeners:active];
                    [finalSeminars addObject: finalSeminarModel];
                    [finalSeminarModel release];
                    [oppo sortUsingSelector:@selector(sortByName:)];
                    [active sortUsingSelector:@selector(sortByName:)];
                    [oppo release];
                    [active release];
                }
                
                [UserListSingleton instance].mutableArray = allUsers;
                
                ProjectModel *projectModel = [[ProjectModel alloc] initWithTitle:[[projectDict objectAtIndex:i] objectForKey:@"title"] statusMessage:[[projectDict objectAtIndex:i] objectForKey:@"statusMessage"]  status:status members:members level:[[projectDict objectAtIndex:i] objectForKey:@"level"] reviewer:reviewers coSupervisors:coSupervisors progress: [[projectDict objectAtIndex:i] objectForKey:@"projectProgress"] finalSeminars:finalSeminars];
                [projects addObject:projectModel];
                [projectModel release];
                [members sortUsingSelector:@selector(sortByName:)];
                [reviewers sortUsingSelector:@selector(sortByName:)];
                [finalSeminars sortUsingSelector:@selector(sortByName:)];
                [coSupervisors sortUsingSelector:@selector(sortByName:)];
                [members release];
                [reviewers release];
                [finalSeminars release];
                [coSupervisors release];
                
            }
            [allUsers addObject: [LoginSingleton instance].user];
            [allUsers release];
            
            [projects sortUsingSelector:@selector(sortByStatus:)];
            
            
            
            [[self tableView] reloadData];
            
            
            
            
        } else{
            UIAlertView *errorAlert = [[UIAlertView alloc]
                                       initWithTitle: @"Connection problems"
                                       message: @"Connections problems, try login again."
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
