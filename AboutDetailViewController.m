//
//  AboutDetailViewController.m
//  CircleBrewing
//
//  Created by Matthew Thompson on 3/24/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import "AboutDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AboutDetailViewController ()

@end

@implementation AboutDetailViewController

@synthesize textString;
@synthesize titleString;
@synthesize delegate;

@synthesize topImageView, textLabel, btmImageView, scrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = titleString;
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    [cancelButtonItem release];
	// Do any additional setup after loading the view.
}

-(void)loadView
{
    [super loadView];
    
    [self.view setAutoresizesSubviews:YES];
    
    UIScreen *myScreen = [UIScreen mainScreen];
    CGSize screenSize = [myScreen applicationFrame].size;
    
    //Initialize the scroll view for the about page - content size will be defined in viewWillLayoutSubviews
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.bounces = NO;
    scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    topImageView = [[UIImageView alloc] init];
    topImageView.image = [UIImage imageNamed:@"storypic1.jpg"];
    [scrollView addSubview:topImageView];
    [topImageView release];
    
    textLabel = [[UILabel alloc] init];
    textLabel.numberOfLines = 0;
    textLabel.lineBreakMode = UILineBreakModeWordWrap;
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    textLabel.text = textString;
    textLabel.layer.cornerRadius = 8;
    [textLabel sizeToFit];
    [scrollView addSubview:textLabel];
    [textLabel release];
    
    btmImageView = [[UIImageView alloc] init];
    btmImageView.image = [UIImage imageNamed:@"storypic2.jpg"];
    [scrollView addSubview:btmImageView];
    [btmImageView release];
    
    [self.view addSubview:scrollView];
    [scrollView release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    UIScreen *myScreen = [UIScreen mainScreen];
    CGSize screenSize = [myScreen bounds].size;
    
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) 
    {        
        self.topImageView.frame = CGRectMake(0, 0, screenSize.height, 142);
        self.textLabel.frame = CGRectMake(20, CGRectGetMaxY(self.topImageView.frame)+20, screenSize.height-40, 50);
        [self.textLabel sizeToFit];
        self.btmImageView.frame = CGRectMake(0, CGRectGetMaxY(self.textLabel.frame)+20, screenSize.height, 142);
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.height, CGRectGetMaxY(self.btmImageView.frame));
    }
    else 
    {
        self.topImageView.frame = CGRectMake(0, 0, screenSize.width, 142);
        self.textLabel.frame = CGRectMake(20, CGRectGetMaxY(self.topImageView.frame)+20, screenSize.width-40, 50);
        [self.textLabel sizeToFit];
        self.btmImageView.frame = CGRectMake(0, CGRectGetMaxY(self.textLabel.frame)+20, screenSize.width, 142);
        
        scrollView.contentSize = CGSizeMake(screenSize.width, CGRectGetMaxY(self.btmImageView.frame));
    }
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
}

-(void)viewWillLayoutSubviews
{
    UIScreen *myScreen = [UIScreen mainScreen];
    CGSize screenSize = [myScreen bounds].size;
    
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) 
    {        
        self.topImageView.frame = CGRectMake(0, 0, screenSize.height, 142);
        self.textLabel.frame = CGRectMake(20, CGRectGetMaxY(self.topImageView.frame)+20, screenSize.height-40, 50);
        [self.textLabel sizeToFit];
        self.btmImageView.frame = CGRectMake(0, CGRectGetMaxY(self.textLabel.frame)+20, screenSize.height, 142);
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.height, CGRectGetMaxY(self.btmImageView.frame));
    }
    else 
    {
        self.topImageView.frame = CGRectMake(0, 0, screenSize.width, 142);
        self.textLabel.frame = CGRectMake(20, CGRectGetMaxY(self.topImageView.frame)+20, screenSize.width-40, 50);
        [self.textLabel sizeToFit];
        self.btmImageView.frame = CGRectMake(0, CGRectGetMaxY(self.textLabel.frame)+20, screenSize.width, 142);
        
        scrollView.contentSize = CGSizeMake(screenSize.width, CGRectGetMaxY(self.btmImageView.frame));
    }
}

-(void)cancel
{
    [self.delegate CloseView];
}

-(void)dealloc
{
    [textString release];
    
    [super dealloc];
}

@end
