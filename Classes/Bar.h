//
//  Bar.h
//  CircleBrewing
//
//  Created by Matthew Thompson on 1/28/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Bar : NSObject
{
    NSString *_name;
    NSString *_address;
    NSString *_phone;
    NSArray *beersOnTap;
    NSString *_twitter;

    CLLocationCoordinate2D myLocation;
    NSString *_description;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSArray *beersOnTap;
@property (nonatomic, copy) NSString *twitter;

@property CLLocationCoordinate2D myLocation;
@property (nonatomic, copy) NSString *description;

-(id)initWithName:(NSString *)name address:(NSString *)address phone:(NSString *)phone beers:(NSArray *)beers twitter:(NSString *)twitter;

@end
