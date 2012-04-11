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

@class Bar;
@class BeerTableViewCell;

@interface BarDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
{
    UITableView *myTableView;
    Bar *myBar;
    BeerTableViewCell *myBeerTableViewCell;
    NSArray *_beerArray;
}

@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) Bar *myBar;
@property (nonatomic, assign) BeerTableViewCell *myBeerTableViewCell;
@property (nonatomic, retain) NSArray *beerArray;

-(void)optionButtonPressed;
-(void)sendTweet;

-(void)favoritesPushed:(id)sender;

-(BOOL)isFeaturedBar;

@end
