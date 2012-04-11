//
//  MyMapAnnotation.m
//  CircleBrewing
//
//  Created by Matthew Thompson on 4/7/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import "MyMapAnnotation.h"

@implementation MyMapAnnotation

@synthesize myBar;

-(CLLocationCoordinate2D)coordinate
{
    return myBar.myLocation;
}

-(NSString *)title
{
    return myBar.name;
}

-(NSString *)subtitle
{
    return nil;
}

-(void)dealloc
{
    [myBar release];
    [super dealloc];
}

@end
