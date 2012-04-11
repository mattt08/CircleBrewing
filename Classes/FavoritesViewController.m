//
//  FavoritesViewController.m
//  CircleBrewing
//
//  Created by Matthew Thompson on 1/14/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import "FavoritesViewController.h"
#import "FavoritesDB.h"
#import "MyFavorite.h"
#import "MyDB.h"
#import "Beer.h"
#import "Bar.h"
#import "BarDetailTableViewCell.h"

@implementation FavoritesViewController

@synthesize myTableView, barArray, beerArray;
@synthesize myBeerTableViewCell;

#define BarSection  0
#define BeerSection 1

#pragma mark - Initialization and Memory Management

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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)dealloc
{
    [barArray release];
    [beerArray release];
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Favorites";
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
    
    [self refreshData];
    
    [myTableView reloadData];
}

#pragma mark - Database management

-(void)refreshData
{
    NSArray *favoriteBars = [[FavoritesDB dB] favoriteBars];
    NSArray *favoriteBeers = [[FavoritesDB dB] favoriteBeers];
    
    self.beerArray = [[MyDB database] getBeerInfoForBeer:favoriteBeers];
    self.barArray = [[MyDB database] getBarInfoForBar:favoriteBars];
}


#pragma mark - Table view data source

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger rows = 0;
    
    switch (section) 
    {
        case BarSection:
            rows = [barArray count];
            break;
        case BeerSection:
            rows = [beerArray count];
            break;
        default:
            break;
    }
    
    if ([barArray count] > 0 || [beerArray count] > 0) 
    {
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
    else
    {
        [self.myTableView setEditing:NO];
        [self setEditing:NO];
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    return rows;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    
    switch (section) 
    {
        case BarSection:
            title = @"My Favorite Bars";
            break;
        case BeerSection:
            title = @"My Favorite Beers";
            break;
        default:
            break;
    }
    
    return title;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat myHeight = 0.0f;
    
    switch (indexPath.section) 
    {
        case BeerSection:
            //only one row - will use BeerTableViewCell nib to display image
            myHeight = 60;
            break;
        case BarSection:
            myHeight = [self getBarLabelSize:indexPath];
            break;
        default:
            break;
    }
    
    return myHeight;
}

#pragma mark - Sizing Functions

-(CGFloat)getBarLabelSize:(NSIndexPath *)indexPath
{
    CGFloat myHeight = 0.0f;
    
    if ([barArray count] > 0) 
    {
        Bar *myBar = [barArray objectAtIndex:indexPath.row];
        
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *BarCellIdentifier = @"BarCell";
    static NSString *BeerCellIdentifier = @"BeerCell";
    
    if (indexPath.section == BarSection) 
    {
        BarDetailTableViewCell *cell = (BarDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BarCellIdentifier];
        
        if (cell == nil) 
        {
            cell = [[[BarDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BarCellIdentifier] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        Bar *info = [barArray objectAtIndex:indexPath.row];
        
        [cell setMyBar:info];
        
        return cell;
    }
    else if (indexPath.section == BeerSection)
    {
        BeerTableViewCell *cell = (BeerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BeerCellIdentifier];
        
        if (cell == nil) 
        {
            cell = [[[BeerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BeerCellIdentifier] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        Beer *myBeer = [beerArray objectAtIndex:indexPath.row];
        
        [cell setMyBeer:myBeer];
        
        return cell;
    }
    
    return nil;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

-(void)setEditing:(BOOL)editing animated:(BOOL)animated 
{
    [super setEditing:editing animated:animated];
    [self.myTableView setEditing:editing animated:YES];
    
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        [self.myTableView beginUpdates];
        
        MyFavorite *info = nil;
        
        switch (indexPath.section) 
        {
            case BarSection:
                info = [barArray objectAtIndex:indexPath.row];
                break;
            case BeerSection:
                info = [beerArray objectAtIndex:indexPath.row];
                break;
            default:
                break;
        }
        
        [[FavoritesDB dB] deleteFavorite:info.name];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Removed" object:info];
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        switch (indexPath.section) 
        {
            case BarSection:
                [barArray removeObject:info];
                break;
            case BeerSection:
                [beerArray removeObject:info];
                break;
            default:
                break;
        }
         
        [self.myTableView endUpdates];
    }     
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSLog(@"Row was moved");
    
    //MyFavorite *info = nil;
    MyFavorite *info = nil;
    
    if (toIndexPath.section == BarSection) 
    {
        
    }
    else if (toIndexPath.section == BeerSection)
    {
        info = [beerArray objectAtIndex:fromIndexPath.row];
        
        [beerArray removeObjectAtIndex:fromIndexPath.row];
        [beerArray insertObject:info atIndex:toIndexPath.row];
    }
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL status = NO;
    
    if (self.editing) 
    {
        //status = YES;
    }
    else
    {
        status = NO;
    }
    // Return NO if you do not want the item to be re-orderable.
    return status;
}

-(NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) 
    {
        return sourceIndexPath;
    }
    else
    {
        return proposedDestinationIndexPath;
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == BarSection)
    {
        BarDetailViewController *myBarDetailViewController = [[BarDetailViewController alloc] init];
        
        Bar *myBar = [barArray objectAtIndex:indexPath.row];
        
        myBarDetailViewController.myBar = myBar;
        
        [self.navigationController pushViewController:myBarDetailViewController animated:YES];
        [myBarDetailViewController release];
    }
    else if (indexPath.section == BeerSection)
    {
        BeerDetailViewController *myDetailViewController = [[BeerDetailViewController alloc] init];
        
        Beer *myBeer = [beerArray objectAtIndex:indexPath.row];
        
        myDetailViewController.myBeer = myBeer;
        
        [self.navigationController pushViewController:myDetailViewController animated:YES];
        [myDetailViewController release];
    }
}

@end
