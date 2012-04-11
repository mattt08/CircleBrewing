//
//  BarDetailTableViewCell.m
//  CircleBrewing
//
//  Created by Matthew Thompson on 2/26/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import "BarDetailTableViewCell.h"
#import "MyFavorite.h"
#import "CircleBrewingAppDelegate.h"

@implementation BarDetailTableViewCell

@synthesize textLabel, detailTextLabel, favoriteImage;

@synthesize headingImage, distanceLabel;

#define FavoriteSelected    8
#define FavoriteUnselected  9

#define degreesToRadians(degrees) ((degrees) * (M_PI / 180.0))

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        UIView *myContentView = self.contentView;
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        self.textLabel.numberOfLines = 0;
        self.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
        self.textLabel.backgroundColor = [UIColor clearColor];
        [myContentView addSubview:self.textLabel];
        [self.textLabel release];
        
        self.detailTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.textColor = [UIColor grayColor];
        self.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        [myContentView addSubview:self.detailTextLabel];
        [self.detailTextLabel release];
        
        self.favoriteImage = [[UIButton alloc] initWithFrame:CGRectZero];
        self.favoriteImage.contentMode = UIViewContentModeCenter;
        self.favoriteImage.enabled = YES;
        self.favoriteImage.imageView.image = nil;
        [myContentView addSubview:self.favoriteImage];
        [self.favoriteImage release];
        
        self.headingImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        headingImage.contentMode = UIViewContentModeCenter;
        self.headingImage.image = nil;
        [myContentView addSubview:self.headingImage];
        [self.headingImage release];
        
        self.distanceLabel = [[UILabel alloc] init];
        distanceLabel.numberOfLines = 0;
        distanceLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        distanceLabel.textColor = [UIColor grayColor];
        distanceLabel.lineBreakMode = UILineBreakModeWordWrap;
        distanceLabel.backgroundColor = [UIColor clearColor];
        [myContentView addSubview:self.distanceLabel];
        [self.distanceLabel release];
    }
    
    backgroundQueue = dispatch_queue_create("com.circlebrewing.tableview.bgqueue", NULL);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FavoriteRemoved:) name:@"Removed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FavoriteAdded:) name:@"Added" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdated:) name:@"Location" object:nil];
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
        
    if (self.editing) 
    {
        self.textLabel.frame = CGRectMake(self.frame.origin.x + 10, 5, 240, [self labelHeightForString:myBar.name withFont:self.textLabel.font forSize:240.0f]);
        self.detailTextLabel.frame = CGRectMake(self.frame.origin.x + 10, CGRectGetMaxY(self.textLabel.frame) + 5, 190, [self labelHeightForString:myBar.address withFont:self.detailTextLabel.font forSize:190.0f]);
        self.distanceLabel.frame = CGRectMake(CGRectGetMaxX(self.detailTextLabel.frame) + 10, self.detailTextLabel.frame.origin.y + ceil(self.detailTextLabel.frame.size.height/2) - 10, 50, 30);
    }
    else 
    {
        self.textLabel.frame = CGRectMake(self.frame.origin.x + 10, 5, 240, [self labelHeightForString:myBar.name withFont:self.textLabel.font forSize:240.0f]);
        self.detailTextLabel.frame = CGRectMake(self.frame.origin.x + 10, CGRectGetMaxY(self.textLabel.frame) + 5, 190, [self labelHeightForString:myBar.address withFont:self.detailTextLabel.font forSize:190.0f]);
        self.favoriteImage.frame = CGRectMake(CGRectGetMaxX(self.textLabel.frame) + 10, self.textLabel.frame.origin.y + ceilf(self.textLabel.frame.size.height/2) - 10, 25, 25);
        self.headingImage.frame = CGRectMake(CGRectGetMaxX(self.detailTextLabel.frame) + 10, self.detailTextLabel.frame.origin.y + ceilf(self.detailTextLabel.frame.size.height/2) - 10, 20, 20);
        self.distanceLabel.frame = CGRectMake(CGRectGetMaxX(self.headingImage.frame) + 10, self.detailTextLabel.frame.origin.y + ceil(self.detailTextLabel.frame.size.height/2) - 10, 50, 30);
    }
}

-(void)enableHeadingArrow
{
    if ([[CircleBrewingAppDelegate myAppDelegate] locationServicesAreAvailable]) 
    {
        if ([CLLocationManager headingAvailable])
        {
            self.headingImage.image = [UIImage imageNamed:@"HeadingArrowSmall.png"];
            
            dispatch_async(backgroundQueue, ^(void){
                [self rotateImage];
            });
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headingUpdated:) name:@"Heading" object:nil];
        }
    }
    else 
    {
        self.headingImage.image = nil;
    }
}

-(CGFloat)labelHeightForString:(NSString *)myString withFont:(UIFont *)font forSize:(float)size
{
    NSString *cellText = myString;
    CGSize constraintSize = CGSizeMake(size, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    CGFloat mySize = labelSize.height;
    
    return mySize;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Model Management

-(void)setMyBar:(Bar *)bar
{    
    [myBar autorelease];
    myBar = [bar retain];
    
    self.textLabel.text = myBar.name;
    [self.textLabel sizeToFit];
    
    self.detailTextLabel.text = myBar.address;
    [self.detailTextLabel sizeToFit];
    
    if ([[CircleBrewingAppDelegate myAppDelegate] locationServicesAreAvailable]) 
    {
        dispatch_async(backgroundQueue, ^(void){
           [self updateDistanceLabel]; 
        });
    }
    else 
    {
        self.distanceLabel.text = nil;
    }
}

-(Bar *)myBar
{
    return myBar;
}

-(void)rotateImage
{
    CircleBrewingAppDelegate *appDelegate = (CircleBrewingAppDelegate *)[UIApplication sharedApplication].delegate;
    
    CLLocation *userLocation = appDelegate.myLocationManager.location;
    CLLocationDirection userDirection = [appDelegate getUserHeading];
    
    CLLocation *barLocation = [[CLLocation alloc] initWithLatitude:myBar.myLocation.latitude longitude:myBar.myLocation.longitude];
    
    CLLocationDirection newDirection = [appDelegate directionToLocation:barLocation fromLocation:userLocation];
    [barLocation release];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        self.headingImage.transform = CGAffineTransformMakeRotation(degreesToRadians(newDirection-userDirection-360));
    });
}

-(void)headingUpdated:(NSNotification *)notification
{
    dispatch_async(backgroundQueue, ^(void){
        [self rotateImage];
    });
}

-(void)locationUpdated:(NSNotification *)notification
{
    dispatch_async(backgroundQueue, ^(void){
        [self updateDistanceLabel];
    });
}

-(void)updateDistanceLabel
{
    CircleBrewingAppDelegate *appDelegate = (CircleBrewingAppDelegate *)[UIApplication sharedApplication].delegate;
    
    CLLocation *userLocation = appDelegate.myLocationManager.location;
    
    CLLocation *barLocation = [[CLLocation alloc] initWithLatitude:myBar.myLocation.latitude longitude:myBar.myLocation.longitude];
    
    CLLocationDistance distance = [userLocation distanceFromLocation:barLocation];
    [barLocation release];
    
    double distanceInMiles = distance/1609.344;
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        if (distanceInMiles < 100.0f) 
        {
            self.distanceLabel.text = [NSString stringWithFormat:@"%.1f mi",distanceInMiles];
        }
        else 
        {
            self.distanceLabel.text = [NSString stringWithFormat:@"%.0f mi",distanceInMiles];
        }
    });
    
}

#pragma mark - Notification Handling

-(void)FavoriteRemoved:(NSNotification *)notification
{
    if ([notification.object isKindOfClass:[Bar class]]) 
    {
        Bar *info = notification.object;
        if ([myBar.name isEqualToString:info.name]) 
        {
            if (self.favoriteImage.imageView.image != nil) 
            {
                [self.favoriteImage setImage:nil forState:UIControlStateNormal];
                [self.favoriteImage setImage:[UIImage imageNamed:@"FavoriteUnselected.png"] forState:UIControlStateNormal];
                self.favoriteImage.tag = FavoriteUnselected;
            }
        }
    }
    else
    {
        if (self.favoriteImage.imageView.image != nil) 
        {
            [self.favoriteImage setImage:nil forState:UIControlStateNormal];
            [self.favoriteImage setImage:[UIImage imageNamed:@"FavoriteUnselected.png"] forState:UIControlStateNormal];
            self.favoriteImage.tag = FavoriteUnselected;
        }
    }
}

-(void)FavoriteAdded:(NSNotification *)notification
{
    if (self.favoriteImage.imageView.image != nil) 
    {
        [self.favoriteImage setImage:nil forState:UIControlStateNormal];
        [self.favoriteImage setImage:[UIImage imageNamed:@"FavoriteSelected.png"] forState:UIControlStateNormal];
        self.favoriteImage.tag = FavoriteSelected;
    }
}

#pragma mark - Memory Management

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [myBar release];
    [textLabel release];
    [detailTextLabel release];
    [favoriteImage release];
    [headingImage release];
    
    dispatch_release(backgroundQueue);
    
    [super dealloc];
}

@end
