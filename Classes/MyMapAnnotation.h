//
//  MyMapAnnotation.h
//  CircleBrewing
//
//  Created by Matthew Thompson on 4/7/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Bar.h"

@interface MyMapAnnotation : NSObject <MKAnnotation>
{
    Bar *myBar;
}

@property (nonatomic, retain) Bar *myBar;

@end
