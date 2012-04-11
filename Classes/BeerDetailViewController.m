//
//  BeerDetailViewController.m
//  CircleBrewing
//
//  Created by Matthew Thompson on 1/28/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import "BeerDetailViewController.h"
#import "BarDetailViewController.h"
#import "BarDetailTableViewCell.h"
#import "BeerTableViewCell.h"
#import "MyDB.h"
#import "FavoritesDB.h"
#import "ImageViewController.h"

@implementation BeerDetailViewController

@synthesize myBeer, myTableView;
@synthesize barArray = _barArray;

#define NAME_SECTION        0
#define DESCRIPTION_SECTION 1
#define BAR_SECTION         2

#define FavoriteSelected    8
#define FavoriteUnselected  9

#define degreesToRadians(degrees) ((degrees) * (M_PI / 180.0))
#define radiansToDegrees(radians) ((radians) * (180.0 / M_PI))

#pragma mark - View lifecycle
-(void)loadView
{
    [super loadView];
    
    self.view.autoresizesSubviews = YES;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    imgView.image = [UIImage imageNamed:@"Wood.jpg"];
    [imgView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.view addSubview:imgView];
    [imgView release];
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    myTableView.backgroundColor = [UIColor clearColor];
    [myTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    myTableView.delegate = self;
    myTableView.dataSource = self;    
    
    [self.view addSubview:myTableView];
    [myTableView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Beer Details";
    
    self.barArray = [[MyDB database] getBarInfoForBeer:myBeer];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [myTableView deselectRowAtIndexPath:[myTableView indexPathForSelectedRow] animated:YES];
    
    //[myTableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    
    switch (section)
    {
        case BAR_SECTION:
            if ([_barArray count] != 0) 
            {
                title = @"On tap at these locations:";
            }
            break;
        default:
            break;
    }
    
    return title;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(30, 0, tableView.frame.size.width-30, 30)] autorelease];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.textAlignment = UITextAlignmentCenter;
    headerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    headerLabel.text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    
    return headerLabel;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self tableView:tableView titleForHeaderInSection:section] != nil) 
    {
        return 30;
    }
    else
    {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    // Return the number of rows in the section.
    switch (section) 
    {
        case NAME_SECTION:
            rows = 1;
            break;
        case DESCRIPTION_SECTION:
            //only one row - will be used as a description cell
            rows = 1;
            break;
        case BAR_SECTION:
            rows = [_barArray count];
            //should be set to number of results returned by bar query
            break;
        default:
            break;
    }
    
    return rows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellText = myBeer.description;
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat barLabelHeight = [self getBarLabelSize:indexPath];
    
    switch (indexPath.section) 
    {
        case NAME_SECTION:
            return 60;
            //break;
        case DESCRIPTION_SECTION:
            //only one row - will be used as a description cell
            return labelSize.height + 10;
            //break;
        case BAR_SECTION:
            return barLabelHeight;
            //break;
        default:
            return 70;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *NameCellIdentifier = @"NameCell";
    static NSString *CellIdentifier = @"Cell";
    static NSString *BarCellIdentifier = @"BarCell";
    
    if (indexPath.section == NAME_SECTION) 
    {
        BeerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NameCellIdentifier];    
        
        if (cell == nil) 
        {
            cell = [[[BeerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NameCellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [cell setMyBeer:myBeer];
        
        [cell.favoriteButton addTarget:self action:@selector(favoritesPushed:) forControlEvents:UIControlEventTouchUpInside];
        if ([[FavoritesDB dB] favoriteCheck:myBeer.name]) 
        {
            [cell.favoriteButton setImage:[UIImage imageNamed:@"FavoriteSelected.png"] forState:UIControlStateNormal];
            cell.favoriteButton.tag = FavoriteSelected;
        }
        else 
        {
            [cell.favoriteButton setImage:[UIImage imageNamed:@"FavoriteUnselected.png"] forState:UIControlStateNormal];
            cell.favoriteButton.tag = FavoriteUnselected;
        }
        
        return cell;
    }
    else if (indexPath.section == DESCRIPTION_SECTION)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) 
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17];

        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = myBeer.description;
        [cell.textLabel sizeToFit];
        cell.userInteractionEnabled = NO;
        
        return cell;
    }
    else
    {
        BarDetailTableViewCell *cell = (BarDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BarCellIdentifier];
        
        if (cell == nil) 
        {
            cell = [[[BarDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BarCellIdentifier] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        Bar *info = [_barArray objectAtIndex:indexPath.row];
        
        [cell setMyBar:info];
        
        if ([[[self.navigationController viewControllers] objectAtIndex:[[self.navigationController viewControllers] count]-2] isKindOfClass:[BarDetailViewController class]]) 
        {
            cell.userInteractionEnabled = NO;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return cell;

    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == NAME_SECTION) 
    {
        if (myBeer.beerImage) 
        {
            ImageViewController *myImageViewController = [[ImageViewController alloc] init];
            myImageViewController.myImage = myBeer.beerImage;
            
            [self.navigationController pushViewController:myImageViewController animated:YES];
            [myImageViewController release];
            
        }
    }
    else if (indexPath.section == BAR_SECTION) 
    {
        Bar *myBar = [_barArray objectAtIndex:indexPath.row];
        
        BarDetailViewController *myBarDetailViewController = [[BarDetailViewController alloc] init];
        
        myBarDetailViewController.myBar = myBar;
        
        [self.navigationController pushViewController:myBarDetailViewController animated:YES];
        [myBarDetailViewController release];
    }
}

#pragma mark - Favorites Handling

-(void)favoritesPushed:(id)sender
{
    UIButton *myButton = (UIButton *)sender;
    
    if (myButton.tag == FavoriteUnselected) 
    {
        [[FavoritesDB dB] addFavorite:myBeer.name category:@"Beers"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Added" object:self];
    }
    else if (myButton.tag == FavoriteSelected)
    {
        [[FavoritesDB dB] deleteFavorite:myBeer.name];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Removed" object:self];
    }
}

#pragma mark - Sizing Functions

-(CGFloat)getBarLabelSize:(NSIndexPath *)indexPath
{
    CGFloat myHeight = 0.0f;
    
    if ([_barArray count] > 0) 
    {
        Bar *myBar = [_barArray objectAtIndex:indexPath.row];
        
        NSString *cellText = myBar.name;
        CGSize constraintSize = CGSizeMake(240, MAXFLOAT);
        CGSize labelSize = [cellText sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        
        NSString *detailText = myBar.address;
        CGSize detailConstraintSize = CGSizeMake(190, MAXFLOAT);
        CGSize detailLabelSize = [detailText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14.0] constrainedToSize:detailConstraintSize lineBreakMode:UILineBreakModeWordWrap];
        
        myHeight = labelSize.height + detailLabelSize.height + 15;
    }
    
    return myHeight;
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)dealloc
{
    [myBeer release];
    self.barArray = nil;
    
    [super dealloc];
}

@end
