//
//  BarDetailViewController.m
//  CircleBrewing
//
//  Created by Matthew Thompson on 1/28/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import "BarDetailViewController.h"
#import "BeerDetailViewController.h"
#import "CircleBrewingAppDelegate.h"
#import "FavoritesDB.h"
#import <Twitter/TWTweetComposeViewController.h>
#import "MapViewController.h"

#pragma mark -

@interface BarDetailTableViewCell()

-(void)startImageDownload:(Beer *)theBeer forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation BarDetailViewController

@synthesize myTableView, myBar, myBeerTableViewCell;
@synthesize beerArray = _beerArray;
@synthesize imageDownloadsInProgress;

#define NAME_SECTION 0
#define BEER_SECTION 1
#define MAP_SECTION  2
#define DIRECTION_SECTION   3
#define CALL_SECTION 4

#define FavoriteSelected    8
#define FavoriteUnselected  9

#define DeviceVersion   [[[UIDevice currentDevice] systemVersion] floatValue]

-(BOOL)isFeaturedBar
{
    BOOL featuredBar = NO;
    
    if (![[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[BeerFinderViewController class]]) 
    {
        if ([self.navigationController.viewControllers count] == 1) 
        {
            return YES;
        }
    }
    
    return featuredBar;
}

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
    
    if ([self isFeaturedBar]) 
    {
        self.myBar = [[MyDB database] getFeaturedBar];
        
        UILabel *myLabel = [self myLabel];
        [self.view addSubview:myLabel];
        
        myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(myLabel.frame) + 10, self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(myLabel.frame)-20) style:UITableViewStyleGrouped];
        [myLabel release];
    }
    else 
    {
        myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    }
    
    myTableView.backgroundColor = [UIColor clearColor];
    [myTableView setAutoresizesSubviews:YES];
    [myTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    myTableView.delegate = self;
    myTableView.dataSource = self;    
    
    [self.view addSubview:myTableView];
    [myTableView release];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self isFeaturedBar]) 
    {
        self.navigationItem.title = @"Featured Bar";
    }
    else
    {
        self.navigationItem.title = @"Bar Details";
    }

    self.beerArray = [[MyDB database] getBeerInfoForBar:myBar];
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    UIBarButtonItem *optionButton = [[UIBarButtonItem alloc] initWithTitle:@"Options" style:UIBarButtonItemStylePlain target:self action:@selector(optionButtonPressed)];
	self.navigationItem.rightBarButtonItem = optionButton;
	[optionButton release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [myTableView deselectRowAtIndexPath:[myTableView indexPathForSelectedRow] animated:YES];
}

-(UILabel *)myLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:@"Helvetica" size:17.0f];
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.text = myBar.description;
    label.layer.cornerRadius = 9.0f;
    
    CGSize myHeight = [myBar.description sizeWithFont:label.font constrainedToSize:CGSizeMake(300, MAXFLOAT) lineBreakMode:label.lineBreakMode];
    label.frame = CGRectMake(10, 10, self.view.frame.size.width-20, myHeight.height);
    
    return label;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger rows = 0;
    
    CircleBrewingAppDelegate *appDelegate = (CircleBrewingAppDelegate *)[UIApplication sharedApplication].delegate;
    
    switch (section)
    {
        case NAME_SECTION:
            rows = 1;
            break;
        case BEER_SECTION:
            rows = [_beerArray count];
            break;
        case MAP_SECTION:
            rows = 1;
            break;
        case DIRECTION_SECTION:
            if ([appDelegate locationServicesAreAvailable]) 
            {
                rows = 1;
            }
            break;
        case CALL_SECTION:
            rows = 1;
            break;
        default:
            break;
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *BeerCellIdentifier = @"BeerCell";
    static NSString *ActionCellIdentifier = @"ActionCell";
    
    if (indexPath.section == NAME_SECTION) 
    {
        BarDetailTableViewCell *cell = (BarDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) 
        {
            cell = [[[BarDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        [cell setMyBar:myBar];
        
        [cell.favoriteImage addTarget:self action:@selector(favoritesPushed:) forControlEvents:UIControlEventTouchUpInside];
        if ([[FavoritesDB dB] favoriteCheck:myBar.name]) 
        {
            [cell.favoriteImage setImage:[UIImage imageNamed:@"FavoriteSelected.png"] forState:UIControlStateNormal];
            cell.favoriteImage.tag = FavoriteSelected;
        }
        else
        {
            [cell.favoriteImage setImage:[UIImage imageNamed:@"FavoriteUnselected.png"] forState:UIControlStateNormal];
            cell.favoriteImage.tag = FavoriteUnselected;
        }
        
        [cell enableHeadingArrow];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    if (indexPath.section == BEER_SECTION) 
    {
        BeerTableViewCell *beerCell = (BeerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BeerCellIdentifier];
        
        if (beerCell == nil) 
        {
            beerCell = [[[BeerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BeerCellIdentifier] autorelease];
            beerCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        Beer *myBeer = [_beerArray objectAtIndex:indexPath.row];
        
        [beerCell setMyBeer:myBeer];
        
        if (!myBeer.beerImage) 
        {
            if (tableView.dragging == NO && tableView.decelerating == NO) 
            {
                [self startImageDownload:myBeer forIndexPath:indexPath];  //Do not start downloading image until the user has finished scrolling
                beerCell.myImageView.image = [UIImage imageNamed:@"Placeholder.png"];
            }
        }
        else
        {
            beerCell.myImageView.image = myBeer.beerImage;
        }
        
        if ([[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[BeerFinderViewController class]])
        {
            beerCell.userInteractionEnabled = NO;
            beerCell.accessoryType = UITableViewCellAccessoryNone;
        }
        if ([[self.navigationController viewControllers] count] > 1) 
        {
            if ([[[self.navigationController viewControllers] objectAtIndex:[[self.navigationController viewControllers] count]-2] isKindOfClass:[BeerDetailViewController class]]) 
            {
                beerCell.userInteractionEnabled = NO;
                beerCell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        
        return beerCell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ActionCellIdentifier];
        
        if (cell == nil) 
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ActionCellIdentifier] autorelease];
            cell.textLabel.textAlignment = UITextAlignmentCenter;
        }
        
        switch (indexPath.section)
        {
            case MAP_SECTION:
                cell.textLabel.text = @"View on Map";
                break;
            case DIRECTION_SECTION:
                cell.textLabel.text = @"Get Directions";
                break;
            case CALL_SECTION:
                cell.textLabel.text = @"Call";
                break;
        }
        
        return cell;
    }
}

#pragma mark - Table view delegate

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

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    
    switch (section) 
    {
        case BEER_SECTION:
            title = @"Beers on Tap:";
            break;
        default:
            break;
    }
    
    return title;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat myHeight = 60;
    
    if (indexPath.section == NAME_SECTION)
    {
        NSString *cellText = myBar.name;
        CGSize constraintSize = CGSizeMake(240, MAXFLOAT);
        CGSize labelSize = [cellText sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        
        NSString *detailText = myBar.address;
        CGSize detailConstraintSize = CGSizeMake(190, MAXFLOAT);
        CGSize detailLabelSize = [detailText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14.0] constrainedToSize:detailConstraintSize lineBreakMode:UILineBreakModeWordWrap];
        
        myHeight = labelSize.height + detailLabelSize.height + 15;
    }
    else if (indexPath.section == BEER_SECTION)
    {
        myHeight = 60;
    }
    
    return myHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == BEER_SECTION) 
    {
        BeerDetailViewController *myDetailViewController = [[BeerDetailViewController alloc] init];
        
        Beer *myBeer = [_beerArray objectAtIndex:indexPath.row];
        
        myDetailViewController.myBeer = myBeer;
        
        [self.navigationController pushViewController:myDetailViewController animated:YES];
        [myDetailViewController release];
    }
    
    if (indexPath.section == MAP_SECTION) 
    {
        MapViewController *myMapViewController = [[MapViewController alloc] init];
        
        NSArray *barArray = [NSArray arrayWithObject:myBar];
        
        myMapViewController.barArray = barArray;
        
        [self.navigationController pushViewController:myMapViewController animated:YES];
        [myMapViewController release];
        
    }
    if (indexPath.section == DIRECTION_SECTION) 
    {
        [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
        
        CircleBrewingAppDelegate *appDelegate = (CircleBrewingAppDelegate *)[UIApplication sharedApplication].delegate;
        CLLocationCoordinate2D userLocation = [appDelegate getUserLocation];
        
        NSString* addr = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%f,%f&saddr=%f,%f",myBar.myLocation.latitude,myBar.myLocation.longitude, userLocation.latitude, userLocation.longitude];
        NSURL* url = [[NSURL alloc] initWithString:[addr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL:url];
        [url release];

    }
    if (indexPath.section == CALL_SECTION) 
    {
        [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
        //Make phone call here
        UIDevice *device = [UIDevice currentDevice];
        if ([[device model] isEqualToString:@"iPhone"] ) 
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",myBar.phone]]];
        } 
        else 
        {
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }

    }
}

#pragma mark - Cell image management

-(void)startImageDownload:(Beer *)theBeer forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    
    if (iconDownloader == nil) 
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.myBeer = theBeer;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        [iconDownloader release];
    }
}

-(void)downloadFailed:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    
    if (iconDownloader != nil) 
    {
        BeerTableViewCell *cell = (BeerTableViewCell *)[self.myTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        cell.myImageView.image = nil;
        
        [cell setNeedsLayout];
    }
}

-(void)appImageDidLoad:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    
    if (iconDownloader != nil) 
    {
        BeerTableViewCell *cell = (BeerTableViewCell *)[self.myTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        cell.myImageView.image = iconDownloader.myBeer.beerImage;
        
        [cell setNeedsLayout];
    }
}

-(void)loadImagesForVisibleRows
{
    if ([self.beerArray count] > 0) 
    {
        NSArray *visiblePaths = [self.myTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths) 
        {
            Beer *myBeer = [_beerArray objectAtIndex:indexPath.row];
            
            if (!myBeer.beerImage) 
            {
                [self startImageDownload:myBeer forIndexPath:indexPath];
            }
        }
    }
}

#pragma mark - Deferred image loading (UIScrollViewDelegate)

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) 
    {
        [self loadImagesForVisibleRows];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForVisibleRows];
}

#pragma mark - Button interaction methods

-(void)favoritesPushed:(id)sender
{
    UIButton *myButton = (UIButton *)sender;
    
    if (myButton.tag == FavoriteUnselected) 
    {
        [[FavoritesDB dB] addFavorite:myBar.name category:@"Bars"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Added" object:self];
    }
    else if (myButton.tag == FavoriteSelected)
    {
        [[FavoritesDB dB] deleteFavorite:myBar.name];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Removed" object:self];
    }
}

#pragma mark - ActionSheet Delegate Handling

-(void)optionButtonPressed
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Options" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    if ([[FavoritesDB dB] favoriteCheck:myBar.name]) 
    {
        [actionSheet addButtonWithTitle:@"Remove from Favorites"];
    }
    else
    {
        [actionSheet addButtonWithTitle:@"Add to Favorites"];
    }

    Class tweetClass = NSClassFromString(@"TWTweetComposeViewController");
    
    if (tweetClass != nil) 
    {
        if ([TWTweetComposeViewController canSendTweet]) 
        {
            [actionSheet addButtonWithTitle:@"Tweet this location"];
        }
    }
    
    [actionSheet addButtonWithTitle:@"Cancel"];
	actionSheet.cancelButtonIndex = actionSheet.numberOfButtons-1;
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    [actionSheet release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *titleString = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([titleString isEqualToString:@"Remove from Favorites"])
    {
        [[FavoritesDB dB] deleteFavorite:myBar.name];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Removed" object:self];
    }
    else if ([titleString isEqualToString:@"Add to Favorites"])
    {
        [[FavoritesDB dB] addFavorite:myBar.name category:@"Bars"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Added" object:self];
    }
    else if ([titleString isEqualToString:@"Tweet this location"])
    {
        [self sendTweet];    
    }
}

#pragma mark - Twitter integration

-(void)sendTweet
{
    if ([TWTweetComposeViewController canSendTweet]) 
    {
        TWTweetComposeViewController *tweetController = [[TWTweetComposeViewController alloc] init];
        
        NSString *initialText = [NSString stringWithFormat:@"\n"];
        if (![myBar.twitter isEqualToString:@"None"]) 
        {
            initialText = [initialText stringByAppendingFormat:@"%@",myBar.twitter];
        }
        
        initialText = [initialText stringByAppendingFormat:@" @circlebrew"];
        
        [tweetController setInitialText:initialText];
        
        [self presentModalViewController:tweetController animated:YES];
        [tweetController release];
        
        tweetController.completionHandler = ^(TWTweetComposeViewControllerResult result) 
        {
            NSString *title = @"Tweet Status";
            NSString *msg; 
            
            if (result == TWTweetComposeViewControllerResultCancelled)
                msg = @"Tweet compostion was canceled.";
            else if (result == TWTweetComposeViewControllerResultDone)
                msg = @"Tweet composition completed.";
            
            // Show alert to see how things went...
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alertView show];
            
            // Dismiss the controller
            [self dismissModalViewControllerAnimated:YES];
        };
        
    }
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
    [myBar release];
    self.beerArray = nil;
    
    [[self.imageDownloadsInProgress allValues] makeObjectsPerformSelector:@selector(cancelDownload)];
    [imageDownloadsInProgress release];
    
    [super dealloc];
}

@end
