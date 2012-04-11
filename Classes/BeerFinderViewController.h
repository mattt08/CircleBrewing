//
//  BeerFinderViewController.h
//  CircleBrewing
//
//  Created by Matthew Thompson on 10/29/11.
//  Copyright 2011 MCTAP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeerListViewController.h"
#import "BarListViewController.h"

@interface BeerFinderViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> 
{
    UITableView *myTableView;
    NSArray *searchArray;
}

@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) NSArray *searchArray;

@end
