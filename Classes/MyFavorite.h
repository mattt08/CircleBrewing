//
//  MyFavorite.h
//  CircleBrewing
//
//  Created by Matthew Thompson on 2/19/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyFavorite : NSObject
{
    NSString *_category;
    NSString *_name;
}

@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSString *name;

-(id)initWithCategory:(NSString *)category name:(NSString *)name;

@end
