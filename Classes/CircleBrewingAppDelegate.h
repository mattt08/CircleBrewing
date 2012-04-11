//
//  CircleBrewingAppDelegate.h
//  CircleBrewing
//
//  Created by Matthew Thompson on 10/29/11.
//  Copyright 2011 MCTAP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BeerFinderViewController.h"
#import "BarDetailViewController.h"
#import "AboutViewController.h"
#import "FavoritesViewController.h"
#import "MapViewController.h"
#import "EventsViewController.h"

@class BeerFinderViewController;
@class AboutViewController;
@class FavoritesViewController;
@class WeeklyBarController;
@class MapViewController;
@class EventsViewController;

@interface CircleBrewingAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, CLLocationManagerDelegate> {
    UIWindow *window;
	UITabBarController *myTabBarController;
	
	BeerFinderViewController *myBeerFinder;
	AboutViewController *aboutCircle;
    FavoritesViewController *myFavoritesController;
    BarDetailViewController *myFeaturedBarController;
    MapViewController *myMapController;
    EventsViewController *myEventsController;
    NSDate *launchDate;
    
    CLLocationManager *myLocationManager;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) BeerFinderViewController *myBeerFinder;
@property (nonatomic, retain) AboutViewController *aboutCircle;
@property (nonatomic, retain) FavoritesViewController *myFavoritesController;
@property (nonatomic, retain) BarDetailViewController *myWeeklyBarController;
@property (nonatomic, retain) MapViewController *myMapController;
@property (nonatomic, retain) EventsViewController *myEventsController;

@property (nonatomic, retain) NSDate *launchDate;

@property (nonatomic, retain) CLLocationManager *myLocationManager;

-(void)verifyAndStartLocationServices;

-(CLLocationDirection)getUserHeading;
-(CLLocationCoordinate2D)getUserLocation;
-(CLLocationDirection)directionToLocation:(CLLocation *)destLocation fromLocation:(CLLocation *)startLocation;
-(BOOL)locationServicesAreAvailable;

+(CircleBrewingAppDelegate *)myAppDelegate;

@end

