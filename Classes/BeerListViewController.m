//
//  BeerListViewController.m
//  CircleBrewing
//
//  Created by Matthew Thompson on 1/24/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import "BeerListViewController.h"
#import "Beer.h"
#import "MyDB.h"

#pragma mark - 

@interface BeerListViewController() 

-(void)startImageDownload:(Beer *)theBeer forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation BeerListViewController

@synthesize myTableView;
@synthesize beers = _beers;
@synthesize imageDownloadsInProgress;

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
    
    self.navigationItem.title = @"Select a beer";
    
    self.myTableView.rowHeight = 60;
    
    self.beers = [MyDB database].getBeerInfo;
    
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_beers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    BeerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[[BeerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Beer *myBeer = [_beers objectAtIndex:indexPath.row];
    
    [cell setMyBeer:myBeer];
    
    if (!myBeer.beerImage) 
    {
        if (tableView.dragging == NO && tableView.decelerating == NO) 
        {
            [self startImageDownload:myBeer forIndexPath:indexPath];  //Do not start downloading image until the user has finished scrolling
            cell.myImageView.image = [UIImage imageNamed:@"Placeholder.png"];
        }
    }
    else
    {
        cell.myImageView.image = myBeer.beerImage;
    }
    
    return cell;
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
    if ([self.beers count] > 0) 
    {
        NSArray *visiblePaths = [self.myTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths) 
        {
            Beer *myBeer = [_beers objectAtIndex:indexPath.row];
            
            if (!myBeer.beerImage) 
            {
                [self startImageDownload:myBeer forIndexPath:indexPath];
            }
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BeerDetailViewController *myDetailViewController = [[BeerDetailViewController alloc] init];
    
    Beer *myBeer = [_beers objectAtIndex:indexPath.row];
    
    myDetailViewController.myBeer = myBeer;
    
    [self.navigationController pushViewController:myDetailViewController animated:YES];
    [myDetailViewController release];
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

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)dealloc
{
    self.beers = nil;
    
    [[self.imageDownloadsInProgress allValues] makeObjectsPerformSelector:@selector(cancelDownload)];
    [imageDownloadsInProgress release];
    
    [super dealloc];
}

@end
