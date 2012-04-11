//
//  BeerTableViewCell.m
//  CircleBrewing
//
//  Created by Matthew Thompson on 1/24/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import "BeerTableViewCell.h"
#import "FavoritesDB.h"

@implementation BeerTableViewCell

@synthesize myImageView, beerLabel, descriptionLabel, favoriteButton;

#define FavoriteSelected    8
#define FavoriteUnselected  9

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIView *myContentView = self.contentView;
                
        self.myImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.myImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.myImageView.image = nil;
        [myContentView addSubview:self.myImageView];
        [self.myImageView release];
        
        self.beerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.beerLabel.backgroundColor = [UIColor clearColor];
        self.beerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
        [myContentView addSubview:self.beerLabel];
        [self.beerLabel release];
        
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.descriptionLabel.backgroundColor = [UIColor clearColor];
        self.descriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        self.descriptionLabel.textColor = [UIColor grayColor];
        [myContentView addSubview:self.descriptionLabel];
        [self.descriptionLabel release];
        
        self.favoriteButton = [[UIButton alloc] initWithFrame:CGRectZero];
        self.favoriteButton.contentMode = UIViewContentModeCenter;
        self.favoriteButton.imageView.image = nil;
        self.favoriteButton.enabled = YES;
        [myContentView addSubview:self.favoriteButton];
        [self.favoriteButton release];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FavoriteRemoved:) name:@"Removed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FavoriteAdded:) name:@"Added" object:nil];
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.myImageView.image) 
    {
        self.myImageView.frame = CGRectMake(10, 2, 39, 55);
    }
    //self.myImageView.frame = CGRectMake(10, 2, 39, 55);
    self.beerLabel.frame = CGRectMake(CGRectGetMaxX(self.myImageView.frame)+5, 5, 177, 21);
    self.descriptionLabel.frame = CGRectMake(CGRectGetMaxX(self.myImageView.frame)+5, 32, 177, 21);
    self.favoriteButton.frame = CGRectMake(247, 0, 40, 60);
}

#pragma mark - Model management

-(void)setMyBeer:(Beer *)theBeer
{
    [myBeer autorelease];
    myBeer = [theBeer retain];
    
    self.beerLabel.text = myBeer.name;
    self.descriptionLabel.text = myBeer.type;
    
    if (myBeer.beerImage)
    {
        self.myImageView.image = myBeer.beerImage;
    }
}

-(Beer *)myBeer
{
    return myBeer;
}

#pragma mark - Notification handling

-(void)FavoriteRemoved:(NSNotification *)notification
{
    if ([notification.object isKindOfClass:[Beer class]]) 
    {
        Beer *info = notification.object;
        if ([myBeer.name isEqualToString:info.name]) 
        {
            if (self.favoriteButton.imageView.image != nil) 
            {
                [self.favoriteButton setImage:nil forState:UIControlStateNormal];
                [self.favoriteButton setImage:[UIImage imageNamed:@"FavoriteUnselected.png"] forState:UIControlStateNormal];
                self.favoriteButton.tag = FavoriteUnselected;
            }
        }
    }
    else 
    {
        if (self.favoriteButton.imageView.image != nil) 
        {
            [self.favoriteButton setImage:nil forState:UIControlStateNormal];
            [self.favoriteButton setImage:[UIImage imageNamed:@"FavoriteUnselected.png"] forState:UIControlStateNormal];
            self.favoriteButton.tag = FavoriteUnselected;
        }
    }
}

-(void)FavoriteAdded:(NSNotification *)notification
{
    if (self.favoriteButton.imageView.image != nil) 
    {
        [self.favoriteButton setImage:nil forState:UIControlStateNormal];
        [self.favoriteButton setImage:[UIImage imageNamed:@"FavoriteSelected.png"] forState:UIControlStateNormal];
        self.favoriteButton.tag = FavoriteSelected;
    }
}

#pragma mark - Memory Management

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [myBeer release];
    [myImageView release];
    [beerLabel release];
    [descriptionLabel release];
    [favoriteButton release];
    
    [super dealloc];
}

@end
