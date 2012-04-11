//
//  FavoritesDB.h
//  CircleBrewing
//
//  Created by Matthew Thompson on 2/19/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface FavoritesDB : NSObject
{
    sqlite3 *_dB;
}

+(FavoritesDB *)dB;
-(void)openDB:(NSString *)DBName;
-(NSArray *)favoriteBars;
-(NSArray *)favoriteBeers;
-(BOOL)favoriteCheck:(NSString *)name;
-(void)addFavorite:(NSString *)name category:(NSString *)category;
-(void)deleteFavorite:(NSString *)name;

@end
