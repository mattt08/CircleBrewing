//
//  BarDetailViewController.h
//  CircleBrewing
//
//  Created by Matthew Thompson on 1/28/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bar.h"
#import "BeerTableViewCell.h"
#import "BarDetailTableViewCell.h"
#import "Beer.h"
#import "MyDB.h"
#import <QuartzCore/QuartzCore.h>
#import "IconDownloader.h"

@interface BarDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, IconDownloaderDelegate>
{
    UITableView *myTableView;
    Bar *myBar;
    BeerTableViewCell *myBeerTableViewCell;
    NSArray *_beerArray;
    NSMutableDictionary *imageDownloadsInProgress;
}

@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) Bar *myBar;
@property (nonatomic, assign) BeerTableViewCell *myBeerTableViewCell;
@property (nonatomic, retain) NSArray *beerArray;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

-(void)optionButtonPressed;
-(void)sendTweet;

-(void)favoritesPushed:(id)sender;

-(BOOL)isFeaturedBar;

-(void)appImageDidLoad:(NSIndexPath *)indexPath;


@end
