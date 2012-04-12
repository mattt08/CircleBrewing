//
//  CircleBrewingAppDelegate.m
//  CircleBrewing
//
//  Created by Matthew Thompson on 10/29/11.
//  Copyright 2011 MCTAP. All rights reserved.
//

#import "CircleBrewingAppDelegate.h"

@implementation CircleBrewingAppDelegate

@synthesize window;
@synthesize myBeerFinder, aboutCircle, myFavoritesController, myMapController, myWeeklyBarController, myEventsController;
@synthesize myLocationManager;
@synthesize launchDate;

static NSString *tabBarSelectedIndex = @"selectedTabIndex";
static NSString *tabBarOrder = @"tabBarOrder";

#define degreesToRadians(degrees) ((degrees) * (M_PI / 180.0))
#define radiansToDegrees(radians) ((radians) * (180.0 / M_PI))

#define DeviceVersion   [[[UIDevice currentDevice] systemVersion] floatValue]

#pragma mark -
#pragma mark Application lifecycle

-(void)applicationDidFinishLaunching:(UIApplication *)application
{
    /*NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    [sharedCache release];*/
    
    launchDate = [[NSDate alloc] init];
    
    /*if ([[UIDevice currentDevice].systemVersion floatValue] >= 5.0) 
    {
        UIImage *NavigationPortraitBackground = [[UIImage imageNamed:@"GradientImage.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [[UINavigationBar appearance] setBackgroundImage:NavigationPortraitBackground forBarMetrics:UIBarMetricsDefault];
    }*/
    
	UINavigationController *myNav;
	
	myTabBarController = [[UITabBarController alloc] init];
	myTabBarController.delegate = self;
    
    NSMutableArray *tabBarControllerArray = [[NSMutableArray alloc] init];
    
    myBeerFinder = [[BeerFinderViewController alloc] init];
    
    myNav = [[UINavigationController alloc] initWithRootViewController:myBeerFinder];
    [myNav.tabBarItem initWithTitle:@"Search" image:[UIImage imageNamed:@"88-beer-mug.png"] tag:0];
    
    [tabBarControllerArray addObject:myNav];
    [myBeerFinder release];
    [myNav release];
    
    myWeeklyBarController = [[BarDetailViewController alloc] init];
    
    myNav = [[UINavigationController alloc] initWithRootViewController:myWeeklyBarController];
    [myNav.tabBarItem initWithTitle:@"Featured Bar" image:nil tag:1];
    
    [tabBarControllerArray addObject:myNav];
    [myWeeklyBarController release];
    [myNav release];
    
    myMapController = [[MapViewController alloc] init];
    
    myNav = [[UINavigationController alloc] initWithRootViewController:myMapController];
    [myNav.tabBarItem initWithTitle:@"Map" image:[UIImage imageNamed:@"72-pin.png"] tag:2];
    
    [tabBarControllerArray addObject:myNav];
    [myMapController release];
    [myNav release];
    
    myEventsController = [[EventsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    myNav = [[UINavigationController alloc] initWithRootViewController:myEventsController];
    [myNav.tabBarItem initWithTitle:@"Events" image:[UIImage imageNamed:@"83-calendar.png"] tag:3];
    
    [tabBarControllerArray addObject:myNav];
    [myEventsController release];
    [myNav release];
    
    myFavoritesController = [[FavoritesViewController alloc] init];
    
    myNav = [[UINavigationController alloc] initWithRootViewController:myFavoritesController];
    [myNav.tabBarItem initWithTitle:@"Favorites" image:[UIImage imageNamed:@"29-heart.png"] tag:4];
    
    [tabBarControllerArray addObject:myNav];
    [myFavoritesController release];
    [myNav release];
    
    aboutCircle = [[AboutViewController alloc] init];
    
    myNav = [[UINavigationController alloc] initWithRootViewController:aboutCircle];
    [myNav.tabBarItem initWithTitle:@"About Circle" image:[UIImage imageNamed:@"59-info.png"] tag:5];
    
    [tabBarControllerArray addObject:myNav];
    [aboutCircle release];
    [myNav release];
    
    //Check to see if user has modified view controller order previously
    NSArray *tabBarOrderArray = [[NSUserDefaults standardUserDefaults] arrayForKey:tabBarOrder];
    if (tabBarOrderArray) //User has previously modified view controller order in tabbarController - reorder default order to match the last user setting
    {
        NSMutableArray *sortedTabBarControllerArray = [NSMutableArray array];
        for (NSNumber *sortNumber in tabBarOrderArray)
        {
            [sortedTabBarControllerArray addObject:[tabBarControllerArray objectAtIndex:[sortNumber intValue]]];
        }
        myTabBarController.viewControllers = sortedTabBarControllerArray;
    }
    else
    {
        myTabBarController.viewControllers = tabBarControllerArray;
    }
    
    [tabBarControllerArray release];
	
    window.rootViewController = myTabBarController;
        
    if ([[NSUserDefaults standardUserDefaults] integerForKey:tabBarSelectedIndex]) 
    {
        if ([[NSUserDefaults standardUserDefaults] integerForKey:tabBarSelectedIndex] == 2147483647) 
        {
            myTabBarController.selectedViewController = myTabBarController.moreNavigationController;
        }
        else 
        {
            myTabBarController.selectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:tabBarSelectedIndex];
        }
        
    }
    
	[window addSubview:myTabBarController.view];
	
	[window makeKeyAndVisible];
    
    [self verifyAndStartLocationServices];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark - 
#pragma mark Tab Bar Controller Delegate Methods

-(void)tabBarController:(UITabBarController *)tabBarController willEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
    //Use this delegate method if you want to prompt user for confirmation that they want to modify view controllers...Currently not planning to use.
}

-(void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
    //User has modified the view controller order in the tab bar. If different that original, execute the following code.
    if (changed) 
    {
        NSMutableArray *tabBarOrderArray = [[NSMutableArray alloc] init];
        for (UIViewController *vc in viewControllers) 
        {
            [tabBarOrderArray addObject:[NSNumber numberWithInt:[[vc tabBarItem] tag]]];
            //Iterate through view controllers and grab the tag from each. This will be used to reorder the view controllers at app restart.
        }
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:tabBarOrderArray] forKey:tabBarOrder];
        [tabBarOrderArray release];
    }
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [[NSUserDefaults standardUserDefaults] setInteger:tabBarController.selectedIndex forKey:tabBarSelectedIndex];
    //Save the current tab bar index, will be used to restore the last tab that the user was on at app restart.
}


#pragma mark - 
#pragma mark Location Management

//The following section of code will be used to determine if user location services are enabled. If this is the app's first launch, it will prompt the user for permission.
//If the user has enabled location services, it will start monitoring location. If the user is using a phone that has the ability to get heading, it will start monitoring heading as well.
-(void)verifyAndStartLocationServices
{
    if ([CLLocationManager locationServicesEnabled]) 
    {
        myLocationManager = [[CLLocationManager alloc] init];
        myLocationManager.delegate = self;
        myLocationManager.headingFilter = 3.0;
        myLocationManager.distanceFilter = 160.9f;
        myLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        myLocationManager.purpose = @"This will help you find new places nearby and get directions/distances to all kinds of good Circle Brewing stuff";
        
        if ([self locationServicesAreAvailable]) 
        {
            [myLocationManager startUpdatingLocation];
            
            if ([CLLocationManager headingAvailable])
            {
                [myLocationManager startUpdatingHeading];
            }
        }
        else
        {
            [myLocationManager stopUpdatingLocation];
        }        
    }
}

-(BOOL)locationServicesAreAvailable
{    
    if (DeviceVersion <= 4.1) 
    {
        if ([CLLocationManager locationServicesEnabled]) 
        {
            return YES;
        }
    }
    else
    {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) 
        {
            [myLocationManager startUpdatingLocation];
        }
        
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) 
        {
            return NO;
        }
        else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)
        {
            return NO;
        }
        else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) 
        {
            return YES;
        }
    }
    
    return NO;
}

-(CLLocationCoordinate2D)getUserLocation
{
    return myLocationManager.location.coordinate;
}


-(CLLocationDirection)getUserHeading
{
    return myLocationManager.heading.trueHeading;
}

#pragma mark - 
#pragma mark Location Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Location" object:self];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Heading" object:self];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusDenied:
            [myLocationManager stopUpdatingLocation];
            break;
        case kCLAuthorizationStatusAuthorized:
            [myLocationManager startUpdatingLocation];
            if ([CLLocationManager headingAvailable]) 
            {
                [myLocationManager startUpdatingHeading];
            }
            break;
        default:
            break;
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error == kCLErrorLocationUnknown) 
    {
        //Ignore and wait for a new event
    }
}

-(CLLocationDirection)directionToLocation:(CLLocation *)destLocation fromLocation:(CLLocation *)startLocation
{    
    CLLocationCoordinate2D coord1 = startLocation.coordinate;
    CLLocationCoordinate2D coord2 = destLocation.coordinate;
    
    CLLocationDegrees deltaLong = coord2.longitude - coord1.longitude;
    CLLocationDegrees yComponent = sin(deltaLong) * cos(coord2.latitude);
    CLLocationDegrees xComponent = (cos(coord1.latitude) * sin(coord2.latitude)) - (sin(coord1.latitude) * cos(coord2.latitude) * cos(deltaLong));
    
    CLLocationDegrees radians = atan2(yComponent, xComponent);
    CLLocationDegrees degrees = radiansToDegrees(radians) + 360;
    
    //return degrees;
    return fmod(degrees, 360);
}

#pragma mark - 
#pragma mark App Delegate Methods

+(CircleBrewingAppDelegate *)myAppDelegate
{
    return (CircleBrewingAppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application 
{
    //[self stopLocationServices];
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc 
{
    [window release];
	[myBeerFinder release];
	[aboutCircle release];
    [myFavoritesController release];
    [myMapController release];
    [myWeeklyBarController release];
    [myLocationManager release];
    [myEventsController release];
    
    [super dealloc];
}


@end
