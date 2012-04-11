//
//  FavoritesDB.m
//  CircleBrewing
//
//  Created by Matthew Thompson on 2/19/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import "FavoritesDB.h"
#import "MyFavorite.h"

@implementation FavoritesDB

static FavoritesDB *_dB;
static sqlite3_stmt *myStatement;
static sqlite3_stmt *addStatement;

static NSString *const FavoritesPath = @"FavoritesDB.sqlite";

+(FavoritesDB *)dB
{
    if (_dB == nil) 
    {
        _dB = [[FavoritesDB alloc] init];
    }
    return _dB;
}

-(id)init
{
    if (self == [super init]) 
    {
        BOOL success;
        NSFileManager *fileManager = [NSFileManager defaultManager]; 
		NSError *error; 
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
		NSString *documentsDirectory = [paths objectAtIndex:0]; 
		NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:FavoritesPath];
		success = [fileManager fileExistsAtPath:writableDBPath];
		if (success) //Favorites DB has already been written to the phone's documents directory. File must exist here to allow read/write and not be read-only
		{
			[self openDB:FavoritesPath];
            
			return self;
		}
		else 
		{
			// The writable database does not exist, so copy the default to the appropriate location. File is copied from the main bundle to the phone's documents directory.
			NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:FavoritesPath]; 
			success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error]; 
			if (!success)  
			{ 
				NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]); 
			} 
			
			[self openDB:FavoritesPath];
			
		}
	}
    
	return self;
}

-(void)openDB:(NSString *)DBName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:DBName]; 	
	
	if (sqlite3_open([writableDBPath UTF8String], &_dB) != SQLITE_OK) 
	{
		NSAssert(0,@"Failed to open database");
	}
}

#pragma mark - Memory management

-(void)dealloc
{
	sqlite3_close(_dB);
	
    [super dealloc];
}

-(BOOL)favoriteCheck:(NSString *)name
{
    //Returns a BOOL that determines if the item in question exists in the favorites already. If no match is found for this name, then method returns NO. If a match is found, then YES is returned.
    BOOL check = NO;
    
    NSString *query = [NSString stringWithFormat:@"SELECT name FROM Favorites WHERE name = \"%@\"",name];
    
    if (sqlite3_prepare_v2(_dB, [query UTF8String], -1, &myStatement, nil) == SQLITE_OK) 
    {
        if (sqlite3_step(myStatement) == SQLITE_ROW) 
        {
            check = YES;
        }
    }
    
    sqlite3_reset(myStatement);
    sqlite3_finalize(myStatement);
    
    return check;
}

-(NSArray *)favoriteBars;
{
    NSMutableArray *retval = [[[NSMutableArray alloc] init] autorelease];
    
    NSString *query = @"SELECT Name FROM Favorites WHERE Category = 'Bars'";
    //Create SQL query to get the names for each Bar in Favorites - this will be used to get the Bar object info
    
    if (sqlite3_prepare_v2(_dB, [query UTF8String], -1, &myStatement, nil) == SQLITE_OK) 
    {
        while (sqlite3_step(myStatement) == SQLITE_ROW) 
        {
            char *NameChars = (char *) sqlite3_column_text(myStatement, 0);
            
            NSString *Name = [[NSString alloc] initWithUTF8String:NameChars];
            
            [retval addObject:Name];
            [Name release];
        }
    }
    
    sqlite3_reset(myStatement);
    sqlite3_finalize(myStatement);
    return retval;
}

-(NSArray *)favoriteBeers
{
    NSMutableArray *retval = [[[NSMutableArray alloc] init] autorelease];
    
    NSString *query = @"SELECT Name FROM Favorites WHERE Category = 'Beers'";
    //Create SQL query to get the names for each Beer in Favorites - this will be used to get the Beer object info
    
    if (sqlite3_prepare_v2(_dB, [query UTF8String], -1, &myStatement, nil) == SQLITE_OK) 
    {
        while (sqlite3_step(myStatement) == SQLITE_ROW) 
        {
            char *NameChars = (char *) sqlite3_column_text(myStatement, 0);
            
            NSString *Name = [[NSString alloc] initWithUTF8String:NameChars];

            [retval addObject:Name];
            [Name release];
        }
    }
    
    sqlite3_reset(myStatement);
    sqlite3_finalize(myStatement);
    return retval;
}

-(void)addFavorite:(NSString *)name category:(NSString *)category
{
    const char *entry = "INSERT INTO Favorites(Category, Name) VALUES(?,?)";
    
    if (sqlite3_prepare_v2(_dB, entry, -1, &addStatement, nil) == SQLITE_OK) 
    {
        sqlite3_bind_text(addStatement, 1, [category UTF8String], -1, SQLITE_STATIC);
        sqlite3_bind_text(addStatement, 2, [name UTF8String], -1, SQLITE_STATIC);
        
        if (sqlite3_step(addStatement) != SQLITE_DONE) 
        {
            NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(_dB));
        }
    }
    
    sqlite3_reset(addStatement);
    sqlite3_finalize(addStatement);
}

-(void)deleteFavorite:(NSString *)name
{
	NSString *sql = [NSString stringWithFormat:@"DELETE FROM Favorites WHERE name = \"%@\"", name];
	sqlite3_exec(_dB, [sql UTF8String], nil, nil, nil);
}


@end
