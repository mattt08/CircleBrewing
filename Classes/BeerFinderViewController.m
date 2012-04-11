//
//  BeerFinderViewController.m
//  CircleBrewing
//
//  Created by Matthew Thompson on 10/29/11.
//  Copyright 2011 MCTAP. All rights reserved.
//

#import "BeerFinderViewController.h"
#import "CircleBrewingAppDelegate.h"
#import "MyDB.h"


@implementation BeerFinderViewController

@synthesize searchArray, myTableView;

#define TOP_SECTION 0
#define BTM_SECTION 1

#pragma mark -
#pragma mark View lifecycle

-(void)loadView
{
    [super loadView];
    
    self.view.autoresizesSubviews = YES;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    imgView.image = [UIImage imageNamed:@"Wood.jpg"];
    [imgView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.view addSubview:imgView];
    [imgView release];
    
    UIImageView *picView = [[UIImageView alloc] initWithFrame:CGRectMake(103, 10, 114, 114)];
    picView.contentMode = UIViewContentModeScaleToFill;
    picView.image = [UIImage imageNamed:@"iconRetina.png"];
    [self.view addSubview:picView];
    [picView release];
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height - 130) style:UITableViewStyleGrouped];
    myTableView.backgroundColor = [UIColor clearColor];
    [myTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    myTableView.delegate = self;
    myTableView.dataSource = self;    
    
    [self.view addSubview:myTableView];
    [myTableView release];
}

- (void)viewDidLoad {
    [super viewDidLoad];

	self.navigationItem.title = @"Search";
    
    self.myTableView.scrollEnabled = NO;
    
    self.myTableView.rowHeight = 60;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    
    [myTableView deselectRowAtIndexPath:[myTableView indexPathForSelectedRow] animated:YES];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    // Return the number of sections.
    return 2;
}

/*-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    
    switch (section)
    {
        case TOP_SECTION:
            title = @"Choose an option to search by:";
            break;
        case BTM_SECTION:
            title = @"Bottom";
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
}*/


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSInteger rows = 0;
    
    switch (section)
    {
        case TOP_SECTION:
            rows = 1;
            break;
        case BTM_SECTION:
            rows = 1;
            break;
        default:
            break;
    }
    
    return rows;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    switch (indexPath.section) 
    {
        case TOP_SECTION:
            cell.textLabel.text = @"Search by Beer";
            break;
        case BTM_SECTION:
            cell.textLabel.text = @"Search by Bar";
            break;
        default:
            break;
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSInteger row = indexPath.section;
    
    if (row == 0) 
    {
        BeerListViewController *myBeerFinderViewController = [[BeerListViewController alloc] init];
        
        [self.navigationController pushViewController:myBeerFinderViewController animated:YES];
        [myBeerFinderViewController release];
    }
    if (row == 1) 
    {
        BarListViewController *myBarListViewController = [[BarListViewController alloc] init];
        
        [self.navigationController pushViewController:myBarListViewController animated:YES];
        [myBarListViewController release];
        //NSLog(@"Search by bar selected");
        
    }

    
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc 
{
    [searchArray release];
    
    [super dealloc];
}


@end

