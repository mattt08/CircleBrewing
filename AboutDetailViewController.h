//
//  AboutDetailViewController.h
//  CircleBrewing
//
//  Created by Matthew Thompson on 3/24/12.
//  Copyright (c) 2012 MCTAP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailDelegate;

@interface AboutDetailViewController : UIViewController
{
    NSString *textString;
    NSString *titleString;
    id <DetailDelegate> delegate;
    
    UIImageView *topImageView;
    UILabel *textLabel;
    UIImageView *btmImageView;
    
    UIScrollView *scrollView;
}

@property (nonatomic, retain) NSString *titleString;
@property (nonatomic, retain) NSString *textString;
@property (nonatomic, assign) id <DetailDelegate> delegate;

@property (nonatomic, retain) UIImageView *topImageView;
@property (nonatomic, retain) UILabel *textLabel;
@property (nonatomic, retain) UIImageView *btmImageView;

@property (nonatomic, retain) UIScrollView *scrollView;

-(void)cancel;

@end

@protocol DetailDelegate

-(void)CloseView;

@end