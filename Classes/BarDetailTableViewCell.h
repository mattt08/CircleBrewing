//
//  BarDetailTableViewCell.h
//  CircleBrewing
//
//  Created by Matthew Thompson on 2/26/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bar.h"

@interface BarDetailTableViewCell : UITableViewCell
{
    UILabel *textLabel;
    UILabel *detailTextLabel;
    UIImageView *headingImage;
    UILabel *distanceLabel;
    
    UIButton *favoriteImage;
    Bar *myBar;
    
    dispatch_queue_t backgroundQueue;
}

@property (nonatomic, retain) UILabel *textLabel;
@property (nonatomic, retain) UILabel *detailTextLabel;
@property (nonatomic, retain) UIImageView *headingImage;
@property (nonatomic, retain) UILabel *distanceLabel;

@property (nonatomic, retain) UIButton *favoriteImage;

-(CGFloat)labelHeightForString:(NSString *)myString withFont:(UIFont *)font forSize:(float)size;
-(Bar *)myBar;
-(void)setMyBar:(Bar *)bar;

-(void)FavoriteRemoved:(NSNotification *)notification;
-(void)FavoriteAdded:(NSNotification *)notification;

-(void)headingUpdated:(NSNotification *)notification;
-(void)locationUpdated:(NSNotification *)notification;

-(void)updateDistanceLabel;
-(void)rotateImage;
-(void)enableHeadingArrow;

@end
