//
//  BeerDetailViewController.h
//  CircleBrewing
//
//  Created by Matthew Thompson on 1/28/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Beer.h"
#import "Bar.h"
#import "CircleBrewingAppDelegate.h"

@interface BeerDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *myTableView;
    Beer *myBeer;
    NSArray *_barArray;
}

@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) Beer *myBeer;
@property (nonatomic, retain) NSArray *barArray;

-(CGFloat)getBarLabelSize:(NSIndexPath *)indexPath;
-(void)favoritesPushed:(id)sender;

@end
