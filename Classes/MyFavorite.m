//
//  MyFavorite.m
//  CircleBrewing
//
//  Created by Matthew Thompson on 2/19/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import "MyFavorite.h"

@implementation MyFavorite

@synthesize category = _category; 
@synthesize name = _name;

-(id)initWithCategory:(NSString *)category name:(NSString *)name
{
    if (self == [super init]) 
    {
        self.category = category;
        self.name = name;
    }
    
    return self;
}

-(void)dealloc
{
    self.category = nil;
    self.name = nil;
    
    [super dealloc];
}


@end
