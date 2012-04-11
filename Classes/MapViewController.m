//
//  MapViewController.m
//  CircleBrewing
//
//  Created by Matthew Thompson on 1/14/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import "MapViewController.h"
#import "CircleBrewingAppDelegate.h"
#import "Bar.h"
#import "MyMapAnnotation.h"

@implementation MapViewController

@synthesize myMapView, barArray;

static NSString *defaultMapType = @"defaultMap";

#define DeviceVersion   [[[UIDevice currentDevice] systemVersion] floatValue]

-(void)loadLocations
{
    if (self.barArray == nil) 
    {
        self.barArray = [MyDB database].getBarInfo;
    }
    
    NSMutableArray *annotationArray = [[NSMutableArray alloc] init];
    
    for (Bar *myBar in self.barArray)
    {
        MyMapAnnotation *annotation = [[MyMapAnnotation alloc] init];
        
        annotation.myBar = myBar;
        
        [annotationArray addObject:annotation];
        [annotation release];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [myMapView addAnnotations:annotationArray];
        [annotationArray release];
    });
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];

    myMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height - self.navigationController.navigationBar.frame.size.height)];
    myMapView.delegate = self;
    myMapView.showsUserLocation = YES;
     
    if ([[NSUserDefaults standardUserDefaults] integerForKey:defaultMapType]) 
    {
        myMapView.mapType = [[NSUserDefaults standardUserDefaults] integerForKey:defaultMapType];
    }
    
    [self setupMapRegion];
    
    backgroundQueue = dispatch_queue_create("com.circlebrewing.mapview.bgqueue", NULL);
    
    dispatch_async(backgroundQueue, ^(void){
        [self loadLocations]; 
    });

    [self.view addSubview:myMapView];
    [myMapView release];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Map";
    
    UIBarButtonItem *optionButton = [[UIBarButtonItem alloc] initWithTitle:@"Options" style:UIBarButtonItemStylePlain target:self action:@selector(optionPressed)];
    self.navigationItem.rightBarButtonItem = optionButton;
    [optionButton release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    if (myMapView.delegate == nil) 
    {
        myMapView.delegate = self;
    }
    
    if (myMapView.mapType != [[NSUserDefaults standardUserDefaults] integerForKey:defaultMapType]) 
    {
        myMapView.mapType = [[NSUserDefaults standardUserDefaults] integerForKey:defaultMapType];
    }
}

-(void)setupMapRegion
{
    MKCoordinateRegion region;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.015, 0.015);
    
    if ([self.barArray count] == 1) 
    {
        Bar *myBar = [self.barArray objectAtIndex:0];
        
        region = MKCoordinateRegionMake(myBar.myLocation, span);
    }
    else 
    {
        if ([[CircleBrewingAppDelegate myAppDelegate] locationServicesAreAvailable]) 
        {
            if ([CircleBrewingAppDelegate myAppDelegate].launchDate == [[CircleBrewingAppDelegate myAppDelegate].myLocationManager.location.timestamp earlierDate:[CircleBrewingAppDelegate myAppDelegate].launchDate]) 
            {
                myMapView.showsUserLocation = YES;
                region = MKCoordinateRegionMake([CircleBrewingAppDelegate myAppDelegate].myLocationManager.location.coordinate, span);
            }
            else 
            {
                CLLocationDegrees latitude = 30.391217;
                CLLocationDegrees longitude = -97.715577;
                
                CLLocationCoordinate2D defaultLocation = CLLocationCoordinate2DMake(latitude, longitude);
                
                region = MKCoordinateRegionMake(defaultLocation, span);
            }
        }
        else 
        {
            CLLocationDegrees latitude = 30.391217;
            CLLocationDegrees longitude = -97.715577;
            
            CLLocationCoordinate2D defaultLocation = CLLocationCoordinate2DMake(latitude, longitude);
            
            region = MKCoordinateRegionMake(defaultLocation, span);
        }
    }
    
    
    myMapView.region = region;
}

#pragma mark - Notification Handling

#pragma mark - Map View Delegate

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //NSLog(@"Updating user location");
    if (!userLocation.updating) 
    {
        //NSLog(@"User location updated");
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{ 
    if (annotation == mapView.userLocation) 
    {
        return nil;
    }
    
    MKPinAnnotationView *pin = (MKPinAnnotationView *)[self.myMapView dequeueReusableAnnotationViewWithIdentifier:@"annotation"];
    
    if (pin == nil) 
    {
        pin = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation"] autorelease];
        pin.canShowCallout = YES;
    }
    
    if ([self.barArray count] != 1) 
    {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pin.rightCalloutAccessoryView = rightButton;
    }

    return pin;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    BarDetailViewController *myBarDetailViewController = [[BarDetailViewController alloc] init];
    
    MyMapAnnotation *annotation = view.annotation;
    
    myBarDetailViewController.myBar = annotation.myBar;
    
    [self.navigationController pushViewController:myBarDetailViewController animated:YES];
    [myBarDetailViewController release];
}

#pragma mark - Action Sheet Interaction

-(void)optionPressed
{
    UIActionSheet *optionMenu = [[UIActionSheet alloc] initWithTitle:@"Select Map Type" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	
	if (myMapView.mapType == MKMapTypeHybrid) 
    {
        [optionMenu addButtonWithTitle:@"Switch to standard view"];
    }
    else if (myMapView.mapType == MKMapTypeStandard)
    {
        [optionMenu addButtonWithTitle:@"Switch to satellite view"];
    }
    
    if ([[CircleBrewingAppDelegate myAppDelegate] locationServicesAreAvailable]) 
    {
        [optionMenu addButtonWithTitle:@"Center map on my location"];
    }
    
	[optionMenu addButtonWithTitle:@"Cancel"];
    
	optionMenu.cancelButtonIndex = optionMenu.numberOfButtons-1;
	[optionMenu showFromTabBar:self.tabBarController.tabBar];
	[optionMenu release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) 
	{
		if (myMapView.mapType == MKMapTypeHybrid) 
        {
            myMapView.mapType = MKMapTypeStandard;
            [[NSUserDefaults standardUserDefaults] setInteger:MKMapTypeStandard forKey:defaultMapType];
        }
        else if (myMapView.mapType == MKMapTypeStandard)
        {
            myMapView.mapType = MKMapTypeHybrid;
            [[NSUserDefaults standardUserDefaults] setInteger:MKMapTypeHybrid forKey:defaultMapType];
        }
	}
    else if (buttonIndex == 1 && buttonIndex != actionSheet.cancelButtonIndex)
    {
        myMapView.centerCoordinate = myMapView.userLocation.coordinate;
    }
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)dealloc
{
    myMapView.delegate = nil;
    self.barArray = nil;
    
    dispatch_release(backgroundQueue);
    
    [super dealloc];
}

#pragma mark - Autorotation Handling

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
