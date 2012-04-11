//
//  BarListViewController.m
//  CircleBrewing
//
//  Created by Matthew Thompson on 1/29/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import "BarListViewController.h"
#import "BarDetailViewController.h"
#import "CircleBrewingAppDelegate.h"

@implementation BarListViewController

@synthesize myTableView;
@synthesize barArray = _barArray;

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
    
    self.barArray = [[MyDB database] getBarInfo];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Select a bar";
}

- (void)viewDidUnload
{
    self.barArray = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.myTableView deselectRowAtIndexPath:[self.myTableView indexPathForSelectedRow] animated:YES];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_barArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    BarDetailTableViewCell *cell = (BarDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[[BarDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Bar *info = [_barArray objectAtIndex:indexPath.row];
    
    [cell setMyBar:info];
    
    return cell;
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Defines height for each table view cell. Gets bar name for each row, then calculates size of the label with that text. Returns appropriate height for cell
    
    Bar *myBar = [_barArray objectAtIndex:indexPath.row];
    
    CGFloat myHeight = 50;
    
    NSString *cellText = myBar.name;
    CGSize constraintSize = CGSizeMake(240, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    NSString *detailText = myBar.address;
    CGSize detailConstraintSize = CGSizeMake(190, MAXFLOAT);
    CGSize detailLabelSize = [detailText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14.0] constrainedToSize:detailConstraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    myHeight = labelSize.height + detailLabelSize.height + 15;

    return myHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //User selected bar - grab the bar information and send it to the instance of BarDetailViewController. Then push view controller onto navigation stack
    
    Bar *myBar = [_barArray objectAtIndex:indexPath.row];
    
    BarDetailViewController *myBarDetailViewController = [[BarDetailViewController alloc] init];
    
    myBarDetailViewController.myBar = myBar;
    
    [self.navigationController pushViewController:myBarDetailViewController animated:YES];
    [myBarDetailViewController release];
}

-(void)dealloc
{
    self.barArray = nil;

    [super dealloc];
}

@end
