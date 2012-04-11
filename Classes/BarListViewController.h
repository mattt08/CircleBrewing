//
//  BarListViewController.h
//  CircleBrewing
//
//  Created by Matthew Thompson on 1/29/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bar.h"
#import "MyDB.h"
#import "BarDetailTableViewCell.h"

@interface BarListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *myTableView;
    NSArray *_barArray;
}

@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) NSArray *barArray;

@end
