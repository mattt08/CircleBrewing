//
//  MapViewController.h
//  CircleBrewing
//
//  Created by Matthew Thompson on 1/14/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import "CircleBrewingAppDelegate.h"

@interface MapViewController : UIViewController <MKMapViewDelegate, UIActionSheetDelegate>
{
    MKMapView *myMapView;
    NSArray *barArray;
    
    dispatch_queue_t backgroundQueue;
}

@property (nonatomic, retain) MKMapView *myMapView;
@property (nonatomic, retain) NSArray *barArray;

-(void)setupMapRegion;
-(void)optionPressed;
-(void)loadLocations;

@end
