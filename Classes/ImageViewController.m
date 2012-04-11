//
//  ImageViewController.m
//  CircleBrewing
//
//  Created by Matthew Thompson on 3/31/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import "ImageViewController.h"

@implementation ImageViewController

@synthesize myImage;

-(void)loadView
{
    [super loadView];
    
    UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-self.tabBarController.tabBar.frame.size.height)];
    myImageView.contentMode = UIViewContentModeScaleAspectFit;
    myImageView.backgroundColor = [UIColor blackColor];
    myImageView.image = myImage;
    [self.view addSubview:myImageView];
    [myImageView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Photo";
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
    [myImage release];
    
    [super dealloc];
}

@end
