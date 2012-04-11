//
//  BeerListViewController.h
//  CircleBrewing
//
//  Created by Matthew Thompson on 1/24/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeerTableViewCell.h"
#import "BeerDetailViewController.h"
#import "IconDownloader.h"

@interface BeerListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, IconDownloaderDelegate>
{
    UITableView *myTableView;
    NSArray *_beers;
    NSMutableDictionary *imageDownloadsInProgress;
}

@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) NSArray *beers;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

-(void)appImageDidLoad:(NSIndexPath *)indexPath;
-(void)loadImagesForVisibleRows;

@end
