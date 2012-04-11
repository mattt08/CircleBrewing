//
//  Beer.m
//  CircleBrewing
//
//  Created by Matthew Thompson on 1/28/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import "Beer.h"

@implementation Beer

@synthesize beerImage;
@synthesize name = _name;
@synthesize type = _type;
@synthesize description = _description;
@synthesize imageURL = _imageURL;
@synthesize primaryKey;

-(id)initWithName:(NSString *)name type:(NSString *)type description:(NSString *)description imageURL:(NSString *)imageURL
{
    if (self == [super init]) 
    {
        self.name = name;
        self.type = type;
        self.description = description;
        self.imageURL = imageURL;
        self.beerImage = nil;
    }
    
    return self;
}

-(void)dealloc
{
    [beerImage release];
    self.name = nil;
    self.type = nil;
    self.description = nil;
    self.imageURL = nil;
    
    [super dealloc];
}

@end
