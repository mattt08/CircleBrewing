//
//  Beer.h
//  CircleBrewing
//
//  Created by Matthew Thompson on 1/28/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Beer : NSObject
{
    int primaryKey;
    UIImage *beerImage;
    NSString *_name;
    NSString *_type;
    NSString *_description;
    NSString *_imageURL;
}

@property int primaryKey;
@property (nonatomic, retain) UIImage *beerImage;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *imageURL;

-(id)initWithName:(NSString *)name type:(NSString *)type description:(NSString *)description imageURL:(NSString *)imageURL;

@end
