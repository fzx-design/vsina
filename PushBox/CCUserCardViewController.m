//
//  CCUserCardViewController.m
//  PushBox
//
//  Created by Xie Hasky on 11-8-5.
//  Copyright 2011年 同济大学. All rights reserved.
//

#import "CCUserCardViewController.h"
#import "WeiboClient.h"

@implementation CCUserCardViewController

@synthesize newFriendsImageView = _newFriendsImageView;

- (void)dealloc
{
    [_newFriendsImageView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.newFriendsImageView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.user = self.currentUser;
    [self configureView];
}

- (void)showFollowersButtonClicked:(id)sender
{
    [super showFollowersButtonClicked:sender];
    self.newFriendsImageView.hidden = YES;
    WeiboClient *client = [WeiboClient client];
    [client resetUnreadCount:ResetUnreadCountTypeFollowers];
}

@end