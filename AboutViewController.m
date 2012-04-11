//
//  AboutViewController.m
//  CircleBrewing
//
//  Created by Matthew Thompson on 1/14/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import "AboutViewController.h"

@implementation AboutViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)loadView
{
    [super loadView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [imgView setImage:[UIImage imageNamed:@"Wood.jpg"]];
    [imgView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.view addSubview:imgView];
    [imgView release];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height - self.navigationController.navigationBar.frame.size.height)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.bounces = NO;
    
    
    UIButton *myButton = [self labelButton:@"Brewing Philosophy"];
    myButton.frame = CGRectMake(60, 40, 200, 70);
    [scrollView addSubview:myButton];
    
    myButton = [self labelButton:@"Our Story"];
    myButton.frame = CGRectMake(60, 150, 200, 70);
    [scrollView addSubview:myButton];
    
    myButton = [self labelButton:@"Why Circle?"];
    myButton.frame = CGRectMake(60, 260, 200, 70);
    [scrollView addSubview:myButton];
    
    [self.view addSubview:scrollView];
    [scrollView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"About Circle";
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(UIButton *)labelButton:(NSString *)titleText;
{
    UIButton *theButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    theButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0f];
    [theButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [theButton setTitle:titleText forState:UIControlStateNormal];
    return theButton;
}

#pragma mark - Instance Methods

-(void)buttonPressed:(id)sender
{
    UIButton *myButton = (UIButton *)sender;
    
    AboutDetailViewController *detailView = [[AboutDetailViewController alloc] init];
    
    detailView.delegate = self;
    
    if ([myButton.titleLabel.text isEqualToString:@"Brewing Philosophy"]) 
    {
        detailView.textString = @"Our Brewing Philosophy: \n\nPurity. Not a word that you would commonly associate with beer these days. Sad, we know, but true. Adjuncts (rice and cheap sugars) commonly make their way into mass market beers, lowering quality and limiting taste. Thankfully, most beer drinkers can taste that for themselves. Say what you will about brews that add herbs, spices, berries, and fruits. Unfortunately, what most don’t see through is the use of chemicals and additives to clarify, add head retention, stabilize, and artificially enhance poorly brewed beer. \nHow are we different, you ask? We follow the German Purity Law or Reinheitsgebot. Dating back to 1516, the German Purity Law restricts the use of any ingredient other than simply the essential Water, Malt, Hops, and Yeast. Created to protect the quality and purity of the beer in Bavaria, the German Purity Law became a guideline and blueprint for breweries for centuries. The law was abandoned in 1988, but the proudest German breweries continue this legacy and insist on the practice today. \nAt Circle Brewing Company, we couldn’t agree more. All of our beers follow this strict policy of using only the four main ingredients with NONE of the chemicals, cheap additives or adjuncts, or gimmicky fruits or spices. Pure, uncomplicated beers that are great because they were made the way they should be. But a beer is worth a thousand words. Try it and then you’ll know difference.";
        detailView.titleString = myButton.titleLabel.text;
    }
    else if ([myButton.titleLabel.text isEqualToString:@"Our Story"])
    {
        detailView.textString = @"Born and raised in Nashville, TN, we, Ben Sabel(on right) and Judson Mulherin(on left), were childhood friends. Ever since we can remember, we both had a dream to open our own shop. When we were kids, we didn't have a clue what that would be, but we didn't let that stop us from dreaming.\n\nWe let that dream slowly fade into the background of our lives as we both went our ways. After graduating from Purdue in 2004, Jud followed his passion of all things aeronautical, becoming an aviation mechanic and contractor in Denver and then San Diego. Ben graduated from the University of Miami in 2004 with degrees in Finance and Economics. Supplementing his business education, Ben became a Boilermaker as well, earning his MBA at Purdue in 2006. He found his way after grad school to Los Angeles to make it big in the Talent Agency business. We never lost touch, and often met up to kick it, sharing tales of our respective lives in vastly different industries. And while we were both successful, we were both unsatisfied with our careers. As time went by, the feeling didn't dissipate, and the dream returned to us.\n\nWe had always loved beer (how could we not?), and after some serious thought, we decided to dedicate our lives to beer. After some serious planning and some hands-on experience in the industry, we were ready. In February 2008, we moved from California to take our love of beer and our dream to Austin, TX. We wanted to make beer the way many claim to - with only the best ingredients and NONE of the other stuff. ";
        detailView.titleString = myButton.titleLabel.text;
    }
    else if ([myButton.titleLabel.text isEqualToString:@"Why Circle?"])
    {
        detailView.textString = @"People often ask us what the deal is with the name Circle. Understandable, it’s not particularly obvious. Ultimately, we were looking for a name that embodied our brewing philosophy of simplicity and purity in crafting uncomplicated, yet perfect beers. We believe our emphasis on brewing the finest beer from simply four ingredients produces the greatest results. For us, the circle resonates as a symbol of simplicity and perfection and ultimately exemplifies our brewing philosophy. Pure. Perfection.";
        detailView.titleString = myButton.titleLabel.text;
    }
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailView];
    
    [self presentModalViewController:navController animated:YES];
    
    [navController release];
    [detailView release];
}

-(void)CloseView
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Memory Management

-(void)dealloc
{
    [super dealloc];
}

@end
