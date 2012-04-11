//
//  MyDB.h
//  CircleBrewing
//
//  Created by Matthew Thompson on 1/31/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "Beer.h"
#import "Bar.h"
#import "MyFavorite.h"

@interface MyDB : NSObject
{
    sqlite3 *_database;
}

+(MyDB *)database;
-(NSArray *)getBeerInfo;
-(NSArray *)getBarInfoForBeer:(Beer *)myBeer;
-(NSMutableArray *)getBarInfoForBar:(NSArray *)favoriteBars;

-(NSArray *)getBarInfo;
-(NSArray *)getBeerInfoForBar:(Bar *)myBar;
-(NSMutableArray *)getBeerInfoForBeer:(NSArray *)favoriteBeers;

-(Bar *)getFeaturedBar;

@end
