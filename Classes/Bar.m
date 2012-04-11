//
//  Bar.m
//  CircleBrewing
//
//  Created by Matthew Thompson on 1/28/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import "Bar.h"

@implementation Bar

@synthesize name = _name;
@synthesize address = _address;
@synthesize phone = _phone;
@synthesize beersOnTap;
@synthesize twitter = _twitter;

@synthesize myLocation;
@synthesize description;

-(id)initWithName:(NSString *)name address:(NSString *)address phone:(NSString *)phone beers:(NSArray *)beers twitter:(NSString *)twitter
{
    if (self == [super init]) 
    {
        self.name = name;
        self.address = address;
        self.phone = phone;
        self.beersOnTap = beers;
        self.twitter = twitter;
    }
    
    self.description = nil;
    
    return self;
}

-(void)dealloc
{
    self.name = nil;
    self.address = nil;
    self.phone = nil;
    self.beersOnTap = nil;
    self.description = nil;
    self.twitter = nil;
    
    [super dealloc];
}

@end
