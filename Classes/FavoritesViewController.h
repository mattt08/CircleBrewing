//
//  FavoritesViewController.h
//  CircleBrewing
//
//  Created by Matthew Thompson on 1/14/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeerTableViewCell.h"
#import "BeerDetailViewController.h"
#import "BarDetailViewController.h"

@interface FavoritesViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *myTableView;
    NSMutableArray *barArray;
    NSMutableArray *beerArray;
    BeerTableViewCell *myBeerTableViewCell;
}

@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) NSMutableArray *barArray;
@property (nonatomic, retain) NSMutableArray *beerArray;
@property (nonatomic, assign) IBOutlet BeerTableViewCell *myBeerTableViewCell;

-(void)refreshData;
-(CGFloat)getBarLabelSize:(NSIndexPath *)indexPath;

@end
