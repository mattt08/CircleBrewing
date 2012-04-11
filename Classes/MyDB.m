//
//  MyDB.m
//  CircleBrewing
//
//  Created by Matthew Thompson on 1/31/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import "MyDB.h"

@implementation MyDB

static MyDB *_database = nil;
static sqlite3_stmt *statement;

static NSString *const DBPath = @"CircleTest.sqlite";

#pragma mark - Object creation

+(MyDB *)database
{
    if (_database == nil) 
	{
		_database = [[MyDB alloc] init];	
	}
	return _database;
}

-(id)init
{
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DBPath];
    
    if (sqlite3_open([defaultDBPath UTF8String], &_database) != SQLITE_OK) 
    {
        NSAssert(0,@"Failed to open database");
    }
    
    return self;
}

#pragma mark - Memory management

-(void)dealloc
{
	sqlite3_close(_database);
	
    [super dealloc];
}

#pragma mark - Object methods

-(NSArray *)getBeerInfo
{
    NSMutableArray *retval = [[[NSMutableArray alloc] init] autorelease];
    NSString *query = @"SELECT name, classification, description, imageURL, id FROM Beer";
    
    if (sqlite3_prepare_v2(_database,[query UTF8String], -1, &statement, nil) == SQLITE_OK) 
	{
		while (sqlite3_step(statement) != SQLITE_DONE)
		{
			char *nameChars = (char *) sqlite3_column_text(statement, 0);
            char *classChars = (char *) sqlite3_column_text(statement, 1);
            char *descChars = (char *) sqlite3_column_text(statement, 2);
            char *imageURLChars = (char *) sqlite3_column_text(statement, 3);
            int primaryKey = (int) sqlite3_column_int(statement, 4);
            
			NSString *name = [[NSString alloc] initWithUTF8String:nameChars];
            NSString *class = [[NSString alloc] initWithUTF8String:classChars];
            NSString *desc = [[NSString alloc] initWithUTF8String:descChars];
            NSString *URL = [[NSString alloc] initWithUTF8String:imageURLChars];
            
            Beer *info = [[Beer alloc] initWithName:name type:class description:desc imageURL:URL];
            info.primaryKey = primaryKey;
            
            [retval addObject:info];
			[name release];
            [class release];
            [desc release];
            [URL release];
			[info release];
		}
	}
    
	sqlite3_reset(statement);
	sqlite3_finalize(statement);
    
    return retval;
}

-(NSArray *)getBarInfoForBeer:(Beer *)myBeer
{
    int beerID = myBeer.primaryKey;
    
    NSMutableArray *retval = [[[NSMutableArray alloc] init] autorelease];
    NSString *query = [NSString stringWithFormat:@"SELECT Name, address, phone, coordinates, beers, twitter FROM Bar WHERE Beers LIKE '%%%i%%'",beerID];
    
    if (sqlite3_prepare_v2(_database,[query UTF8String], -1, &statement, nil) == SQLITE_OK) 
	{
		while (sqlite3_step(statement) != SQLITE_DONE)
		{
			char *nameChars = (char *) sqlite3_column_text(statement, 0);
            char *addressChars = (char *) sqlite3_column_text(statement, 1);
            char *phoneChars = (char *) sqlite3_column_text(statement, 2);
            char *coordinates = (char *) sqlite3_column_text(statement, 3);
            char *beersOnTap = (char *) sqlite3_column_text(statement, 4);
            char *twitterChars = (char *) sqlite3_column_text(statement, 5);
            
			NSString *name = [[NSString alloc] initWithUTF8String:nameChars];
            NSString *address = [[NSString alloc] initWithUTF8String:addressChars];
            NSString *phone = [[NSString alloc] initWithUTF8String:phoneChars];
            
            NSString *beers = [[NSString alloc] initWithUTF8String:beersOnTap];
            NSArray *beerArray = [beers componentsSeparatedByString:@","];            
            
            NSString *myCoordinates = [[NSString alloc] initWithUTF8String:coordinates];
            NSArray *coordinateArray = [myCoordinates componentsSeparatedByString:@","];
            
            NSString *twitter = [[NSString alloc] initWithUTF8String:twitterChars];
            
            Bar *info = [[Bar alloc] initWithName:name address:address phone:phone beers:beerArray twitter:twitter];

            CLLocationDegrees latitude = [[coordinateArray objectAtIndex:0] floatValue];
            CLLocationDegrees longitude = [[coordinateArray objectAtIndex:1] floatValue];
            
            info.myLocation = CLLocationCoordinate2DMake(latitude, longitude);
            
            [retval addObject:info];
            [name release];
            [address release];
            [phone release];
            [info release];
            [beers release];
            [myCoordinates release];
            [twitter release];
		}
	}
    
	sqlite3_reset(statement);
	sqlite3_finalize(statement);
    
    return retval;
}

-(NSArray *)getBarInfo
{
    NSMutableArray *retval = [[[NSMutableArray alloc] init] autorelease];
    NSString *query = [NSString stringWithFormat:@"SELECT Name, address, phone, twitter, coordinates, beers FROM Bar"];
    
    if (sqlite3_prepare_v2(_database,[query UTF8String], -1, &statement, nil) == SQLITE_OK) 
	{
		while (sqlite3_step(statement) != SQLITE_DONE)
		{
			char *nameChars = (char *) sqlite3_column_text(statement, 0);
            char *addressChars = (char *) sqlite3_column_text(statement, 1);
            char *phoneChars = (char *) sqlite3_column_text(statement, 2);
            char *twitterChars = (char *) sqlite3_column_text(statement, 3);            
            char *coordinates = (char *) sqlite3_column_text(statement, 4);
            char *beersOnTap = (char *) sqlite3_column_text(statement, 5);
            
			NSString *name = [[NSString alloc] initWithUTF8String:nameChars];
            NSString *address = [[NSString alloc] initWithUTF8String:addressChars];
            NSString *phone = [[NSString alloc] initWithUTF8String:phoneChars];
            
            NSString *beers = [[NSString alloc] initWithUTF8String:beersOnTap];
            NSArray *beerArray = [beers componentsSeparatedByString:@","];
            
            NSString *myCoordinates = [[NSString alloc] initWithUTF8String:coordinates];
            NSArray *coordinateArray = [myCoordinates componentsSeparatedByString:@","];
            
            NSString *twitter = [[NSString alloc] initWithUTF8String:twitterChars];
            
            Bar *info = [[Bar alloc] initWithName:name address:address phone:phone beers:beerArray twitter:twitter];
            
            if ([coordinateArray count] > 1) 
            {
                CLLocationDegrees latitude = [[coordinateArray objectAtIndex:0] floatValue];
                CLLocationDegrees longitude = [[coordinateArray objectAtIndex:1] floatValue];
                
                info.myLocation = CLLocationCoordinate2DMake(latitude, longitude);
            }
            
            [retval addObject:info];
            [info release];
            
            [name release];
            [address release];
            [phone release];
            [beers release];
            [myCoordinates release];
            [twitter release];
		}
	}
    
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    
    return retval;
}

-(NSArray *)getBeerInfoForBar:(Bar *)myBar
{
    NSMutableArray *retval = [[[NSMutableArray alloc] init] autorelease];
    NSString *query = [NSString stringWithFormat:@"SELECT name, classification, description, imageURL, id FROM Beer WHERE id IN %@",myBar.beersOnTap];
    
    if (sqlite3_prepare_v2(_database,[query UTF8String], -1, &statement, nil) == SQLITE_OK) 
	{
		while (sqlite3_step(statement) != SQLITE_DONE)
		{
			char *nameChars = (char *) sqlite3_column_text(statement, 0);
            char *classChars = (char *) sqlite3_column_text(statement, 1);
            char *descChars = (char *) sqlite3_column_text(statement, 2);
            char *imageURLChars = (char *) sqlite3_column_text(statement, 3);
            int primaryKey = (int) sqlite3_column_int(statement, 4);
            
			NSString *name = [[NSString alloc] initWithUTF8String:nameChars];
            NSString *class = [[NSString alloc] initWithUTF8String:classChars];
            NSString *desc = [[NSString alloc] initWithUTF8String:descChars];
            NSString *URL = [[NSString alloc] initWithUTF8String:imageURLChars];
            
            Beer *info = [[Beer alloc] initWithName:name type:class description:desc imageURL:URL];
            info.primaryKey = primaryKey;
            
            [retval addObject:info];
            [info release];
			[name release];
            [class release];
            [desc release];
            [URL release];
		}
	}
    
	sqlite3_reset(statement);
	sqlite3_finalize(statement);
    
    return retval;
}

-(Bar *)getFeaturedBar
{
    const char *query = "SELECT name, address, phone, coordinates, beers, description, twitter FROM Bar WHERE Featured = 1";
    
    if (sqlite3_prepare_v2(_database, query, -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) != SQLITE_DONE) 
        {
            char *nameChars = (char *) sqlite3_column_text(statement, 0);
            char *addressChars = (char *) sqlite3_column_text(statement, 1);
            char *phoneChars = (char *) sqlite3_column_text(statement, 2);
            char *coordinates = (char *) sqlite3_column_text(statement, 3);
            char *beersOnTap = (char *) sqlite3_column_text(statement, 4);
            char *descriptionChars = (char *) sqlite3_column_text(statement, 5);
            char *twitterChars = (char *) sqlite3_column_text(statement, 6);
            
            NSString *name = [[NSString alloc] initWithUTF8String:nameChars];
            NSString *address = [[NSString alloc] initWithUTF8String:addressChars];
            NSString *phone = [[NSString alloc] initWithUTF8String:phoneChars];
            NSString *beers = [[NSString alloc] initWithUTF8String:beersOnTap];
            NSString *myCoordinates = [[NSString alloc] initWithUTF8String:coordinates];
            NSString *description = [[NSString alloc] initWithUTF8String:descriptionChars];
            
            NSArray *beerArray = [beers componentsSeparatedByString:@","];
            NSArray *coordinateArray = [myCoordinates componentsSeparatedByString:@","];
            
            NSString *twitter = [[NSString alloc] initWithUTF8String:twitterChars];
            
            Bar *info = [[[Bar alloc] initWithName:name address:address phone:phone beers:beerArray twitter:twitter] autorelease];
            
            CLLocationDegrees latitude = [[coordinateArray objectAtIndex:0] floatValue];
            CLLocationDegrees longitude = [[coordinateArray objectAtIndex:1] floatValue];
            
            info.myLocation = CLLocationCoordinate2DMake(latitude, longitude);
            info.description = description;
            
            [name release];
            [address release];
            [phone release];
            [beers release];
            [description release];
            [myCoordinates release];
            [twitter release];
            
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
            return info;
        }
    }
    
    return nil;
}

-(NSMutableArray *)getBarInfoForBar:(NSArray *)favoriteBars
{
    NSMutableArray *retval = [[[NSMutableArray alloc] init] autorelease];
    
    for (int i = 0; i < [favoriteBars count]; i++) 
    {
        NSString *query = [NSString stringWithFormat:@"SELECT Name, address, phone, coordinates, beers, twitter FROM Bar WHERE Name = \"%@\"",[favoriteBars objectAtIndex:i]];
        
        if (sqlite3_prepare_v2(_database,[query UTF8String], -1, &statement, nil) == SQLITE_OK) 
        {
            while (sqlite3_step(statement) != SQLITE_DONE)
            {
                char *nameChars = (char *) sqlite3_column_text(statement, 0);
                char *addressChars = (char *) sqlite3_column_text(statement, 1);
                char *phoneChars = (char *) sqlite3_column_text(statement, 2);
                char *coordinates = (char *) sqlite3_column_text(statement, 3);
                char *beersOnTap = (char *) sqlite3_column_text(statement, 4);
                char *twitterChars = (char *) sqlite3_column_text(statement, 5);
                
                NSString *name = [[NSString alloc] initWithUTF8String:nameChars];
                NSString *address = [[NSString alloc] initWithUTF8String:addressChars];
                NSString *phone = [[NSString alloc] initWithUTF8String:phoneChars];
                
                NSString *beers = [[NSString alloc] initWithUTF8String:beersOnTap];
                NSString *myCoordinates = [[NSString alloc] initWithUTF8String:coordinates];
                
                NSArray *beerArray = [beers componentsSeparatedByString:@","];
                NSArray *coordinateArray = [myCoordinates componentsSeparatedByString:@","];
                
                NSString *twitter = [[NSString alloc] initWithUTF8String:twitterChars];
                
                Bar *info = [[Bar alloc] initWithName:name address:address phone:phone beers:beerArray twitter:twitter];

                CLLocationDegrees latitude = [[coordinateArray objectAtIndex:0] floatValue];
                CLLocationDegrees longitude = [[coordinateArray objectAtIndex:1] floatValue];
                
                info.myLocation = CLLocationCoordinate2DMake(latitude, longitude);
                
                [retval addObject:info];
                [info release];
                
                [name release];
                [address release];
                [phone release];
                [beers release];
                [twitter release];
                [myCoordinates release];
            }
        }
        
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
    }
    
    return retval;
}

-(NSMutableArray *)getBeerInfoForBeer:(NSArray *)favoriteBeers
{
    NSMutableArray *retval = [[[NSMutableArray alloc] init] autorelease];
    
    int i;
    
    for (i = 0; i < [favoriteBeers count]; i++)
    {
        NSString *query = [NSString stringWithFormat:@"SELECT name, classification, description, imageURL, id FROM Beer WHERE name = \"%@\"",[favoriteBeers objectAtIndex:i]];
        
        if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) 
        {
            while (sqlite3_step(statement) != SQLITE_DONE)
            {
                char *nameChars = (char *) sqlite3_column_text(statement, 0);
                char *classChars = (char *) sqlite3_column_text(statement, 1);
                char *descChars = (char *) sqlite3_column_text(statement, 2);
                char *imageURLChars = (char *) sqlite3_column_text(statement, 3);
                int primaryKey = (int) sqlite3_column_int(statement, 4);
                
                NSString *name = [[NSString alloc] initWithUTF8String:nameChars];
                NSString *class = [[NSString alloc] initWithUTF8String:classChars];
                NSString *desc = [[NSString alloc] initWithUTF8String:descChars];
                NSString *URL = [[NSString alloc] initWithUTF8String:imageURLChars];
                
                Beer *info = [[Beer alloc] initWithName:name type:class description:desc imageURL:URL];
                info.primaryKey = primaryKey;
                
                [retval addObject:info];
                [name release];
                [class release];
                [desc release];
                [URL release];
                [info release];
            }
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
    }
    
    return retval;
}

@end
