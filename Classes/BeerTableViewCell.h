//
//  BeerTableViewCell.h
//  CircleBrewing
//
//  Created by Matthew Thompson on 1/24/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Beer.h"

@interface BeerTableViewCell : UITableViewCell
{
    UIImageView *myImageView;
    UILabel *beerLabel;
    UILabel *descriptionLabel;
    UIButton *favoriteButton;
    
    Beer *myBeer;
}

@property (nonatomic, retain) UIImageView *myImageView;
@property (nonatomic, retain) UILabel *beerLabel;
@property (nonatomic, retain) UILabel *descriptionLabel;
@property (nonatomic, retain) UIButton *favoriteButton;

-(Beer *)myBeer;
-(void)setMyBeer:(Beer *)theBeer;

-(void)FavoriteRemoved:(NSNotification *)notification;
-(void)FavoriteAdded:(NSNotification *)notification;

@end
