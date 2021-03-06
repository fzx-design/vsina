//
//  DockViewController.m
//  PushBox
//
//  Created by Xie Hasky on 11-7-25.
//  Copyright 2011年 同济大学. All rights reserved.
//

#import "DockViewController.h"
#import "User.h"
#import "CastViewController.h" //to get notification defines

@implementation DockViewController

@synthesize currentSliderPositionX;

@synthesize refreshButton = _refreshButton;
@synthesize postButton = _newTweetButton;
@synthesize playButton = _playButton;
@synthesize commandCenterButton = _commandCenterButton;
@synthesize messagesCenterButton = _messagesCenterButton;
@synthesize showFavoritesButton = _showFavoritesButton;
@synthesize optionsButton = _optionsButton;
@synthesize searchButton = _searchButton;

@synthesize groupButton = _groupButton;

@synthesize slider = _slider;
@synthesize refreshNotiImageView = _refreshNotiImageView;
@synthesize commandCenterNotiImageView = _commandCenterNotiImageView;
@synthesize optionsPopoverController = _optionsPopoverController;
@synthesize controlContainerView = _controlContainerView;
@synthesize postingRoundImageView = _postingRoundImageView;
@synthesize postingCircleImageView = _postingCircleImageView;

@synthesize refreshNotiImageShown;

@synthesize userCardNaviViewController = _userCardNaviViewController;
@synthesize ccUserInfoCardViewController = _ccUserInfoCardViewController;
@synthesize commentNaviViewController = _commentNaviViewController;
@synthesize ccCommentTableViewController = _ccCommentTableViewController;

@synthesize hideCommandCenterButton = _hideCommandCenterButton;


#pragma mark - Tool

- (void)setCommandCenter
{
        [[UIApplication sharedApplication] showLoadingView];
    
    self.ccUserInfoCardViewController = [[[CCUserInfoCardViewController alloc] init] autorelease];
	self.ccUserInfoCardViewController.currentUser = self.currentUser;
	self.ccUserInfoCardViewController.managedObjectContext = self.managedObjectContext;
	
	self.userCardNaviViewController = [[[UserCardNaviViewController alloc] initWithRootViewController:self.ccUserInfoCardViewController] autorelease];
	self.userCardNaviViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
	CGRect frame = CGRectMake(-16, 121, self.userCardNaviViewController.view.frame.size.width, self.userCardNaviViewController.view.frame.size.height);
	self.userCardNaviViewController.view.frame = frame;
	[self.view addSubview:self.userCardNaviViewController.view];
	
	self.ccCommentTableViewController = [[[CCCommentsTableViewController alloc] init] autorelease];
	self.ccCommentTableViewController.dataSource = CommentsTableViewDataSourceCommentsToMe;
	self.ccCommentTableViewController.currentUser = self.currentUser;
	self.ccCommentTableViewController.managedObjectContext = self.managedObjectContext;
    self.ccCommentTableViewController.fetchedResultsController.delegate = self.ccCommentTableViewController;
    
	self.commentNaviViewController = [[[UserCardNaviViewController alloc] initWithRootViewController:self.ccCommentTableViewController] autorelease];
	self.commentNaviViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	
	frame = CGRectMake(470, 121, self.commentNaviViewController.view.frame.size.width, self.commentNaviViewController.view.frame.size.height);
	self.commentNaviViewController.view.frame = frame;
	[self.view addSubview:self.commentNaviViewController.view];
}

- (void)clearCommandCenter
{
    [_commentNaviViewController.view removeFromSuperview];
    [_userCardNaviViewController.view removeFromSuperview];
    
    [_commentNaviViewController release];
    [_userCardNaviViewController release];
    [_ccCommentTableViewController release];
    [_ccUserInfoCardViewController release];
    
    _ccUserInfoCardViewController = nil;
    _userCardNaviViewController = nil;
    _ccCommentTableViewController = nil;
    _commentNaviViewController = nil;
    
//    self.ccUserInfoCardViewController = nil;
//    self.ccCommentTableViewController = nil;
//    self.userCardNaviViewController = nil;
//    self.commentNaviViewController = nil;
}

#pragma mark - View lifecycle

- (void)dealloc
{
    [_refreshButton release];
    [_newTweetButton release];
    [_playButton release];
    [_commandCenterButton release];
    [_messagesCenterButton release];
    [_showFavoritesButton release];
    [_optionsButton release];
    
    [_groupButton release];
    
    [_slider release];
    [_controlContainerView release];
    [_refreshNotiImageView release];
    [_commandCenterNotiImageView release];
    [_optionsPopoverController release];
	[_userCardNaviViewController release];
	[_ccUserInfoCardViewController release];
	
	[_postingRoundImageView release];
	[_postingCircleImageView release];
	
	[_commentNaviViewController release];
	[_ccCommentTableViewController release];
	
	[_hideCommandCenterButton release];
	
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.refreshButton = nil;
    self.postButton = nil;
    self.playButton = nil;
    self.commandCenterButton = nil;
    self.messagesCenterButton = nil;
    self.showFavoritesButton = nil;
    self.optionsButton = nil;
    
    self.groupButton = nil;
    
    self.slider = nil;
    self.refreshNotiImageView = nil;
    self.commandCenterNotiImageView = nil;
    self.controlContainerView = nil;
	
	self.postingRoundImageView = nil;
	self.postingCircleImageView = nil;
	
	self.commentNaviViewController = nil;
	self.ccCommentTableViewController = nil;
	
	self.hideCommandCenterButton = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.slider setThumbImage:[UIImage imageNamed:@"dock_slider_thumb.png"] forState:UIControlStateNormal];
	[self.slider setThumbImage:[UIImage imageNamed:@"dock_slider_thumb_HL.png"] forState:UIControlStateHighlighted];
	[self.slider setMinimumTrackImage:[UIImage imageNamed:@"transparent.png"] forState:UIControlStateNormal];
	[self.slider setMaximumTrackImage:[UIImage imageNamed:@"transparent.png"] forState:UIControlStateNormal];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(dismissPopoverNotification:) 
                   name:kNotificationNameShouldDismissPopoverView 
                 object:nil];
    
    [center addObserver:self
               selector:@selector(newCommentsToMeNotification:)
                   name:kNotificationNameNewCommentsToMe object:nil];
	
    [center addObserver:self
               selector:@selector(newStatusesNotification:)
                   name:kNotificationNameNewStatuses object:nil];
    
    [center addObserver:self
               selector:@selector(newFollowersNotification:) 
                   name:kNotificationNameNewFollowers object:nil];
	
	[center addObserver:self
               selector:@selector(newMentionsNotification:) 
                   name:kNotificationNameNewMentions object:nil];
	
	[center addObserver:self 
			   selector:@selector(disableRefreshButton) 
				   name:kNotificationNameDisableRefresh 
				 object:nil];
	
	[center addObserver:self 
			   selector:@selector(enableRefreshButton) 
				   name:kNotificationNameEnableRefresh 
				 object:nil];
	
	[center addObserver:self
			   selector:@selector(notificationRefreshed) 
				   name:kNotificationNameNotificationRefreshed
				 object:nil];
    
    self.refreshNotiImageView.hidden = YES;
	refreshNotiImageShown = YES;
    self.commandCenterNotiImageView.hidden = YES;
	
    self.hideCommandCenterButton.enabled = NO;
    
//    [self setCommandCenter];
	
	[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(calculateRefreshTime) userInfo:nil repeats:YES];
	
    //    self.commentsTableViewController.dataSource = CommentsTableViewDataSourceCommentsToMe;
    //    self.commentsTableViewController.currentUser = self.currentUser;
    //	
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	[self.ccUserInfoCardViewController viewWillAppear:YES];
//	[self.ccCommentTableViewController viewWillAppear:YES];
//    [self.commentsTableViewController viewWillAppear:YES];
}

- (void)calculateRefreshTime
{
	if (!refreshFlag) {
		return;
	}
	
	refreshTime += 1;
	if (refreshTime >= 5) {
		[self hideLoadingView];
	}
}

- (void)showLoadingView
{
	refreshFlag = YES;
	self.refreshButton.enabled = NO;
    self.refreshButton.alpha = 0.0;
	
	_postingCircleImageView.alpha = 1.0;
	_postingRoundImageView.alpha = 1.0;
	
	CABasicAnimation *rotationAnimation =[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
	rotationAnimation.duration = 1.0;
	rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0];
	rotationAnimation.toValue = [NSNumber numberWithFloat:-2.0 * M_PI];
	rotationAnimation.repeatCount = 65535;
	[_postingCircleImageView.layer addAnimation:rotationAnimation forKey:@"kAnimationLoad"];
}

- (void)hideLoadingView
{
	self.refreshButton.enabled = YES;
	refreshFlag = NO;
	refreshTime = 0;
	[UIView animateWithDuration:1.0 animations:^{
		_postingRoundImageView.alpha = 0.0;
		_postingCircleImageView.alpha = 0.0;
        self.refreshButton.alpha = 1.0;
    } completion:^(BOOL finished) {
		[_postingCircleImageView.layer removeAnimationForKey:@"kAnimationLoad"];
	}];
}

- (void)notificationRefreshed
{
	self.commandCenterNotiImageView.hidden = YES;
}

- (void)newCommentsToMeNotification:(id)sender
{
    if (!self.commandCenterButton.selected) {
        self.commandCenterNotiImageView.hidden = NO;
    }
}

- (void)newStatusesNotification:(id)sender
{
    self.refreshNotiImageView.hidden = NO;
	self.refreshNotiImageShown = NO;
}

- (void)newFollowersNotification:(id)sender
{
    if (!self.commandCenterButton.selected) {
        self.commandCenterNotiImageView.hidden = NO;
    }
}

- (void)newMentionsNotification:(id)sender
{
    if (!self.commandCenterButton.selected) {
        self.commandCenterNotiImageView.hidden = NO;
    }
}

- (void)dismissPopoverNotification:(id)sender
{
    [self.optionsPopoverController dismissPopoverAnimated:YES];
}

- (void)showControlsAnimated:(BOOL)animated;
{
    [UIView animateWithDuration:animated animations:^{
        self.controlContainerView.alpha = 1.0;
    }];
}

- (void)hideControlsAnimated:(BOOL)animated;
{
    [UIView animateWithDuration:animated animations:^{
        self.controlContainerView.alpha = 0.0;
    }];
}

- (IBAction)optionsButtonClicked:(id)sender {
    OptionsTableViewController *otvc = [[OptionsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	otvc.name = self.currentUser.screenName;
	
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:otvc];
    
    _optionsPopoverController = [[UIPopoverController alloc] initWithContentViewController:nc];
    self.optionsPopoverController.delegate = self;
    
	CGRect rect = self.optionsButton.bounds;
	rect.origin.x += 7;
	rect.origin.y += 10;
	rect.size.width -= 30;
	rect.size.height -= 30;
    [self.optionsPopoverController presentPopoverFromRect:rect
                                                   inView:self.optionsButton
                                 permittedArrowDirections:UIPopoverArrowDirectionAny
                                                 animated:YES];
    [otvc release];
    [nc release];
}

- (void)enableRefreshButton
{
	self.refreshButton.enabled = YES;
}

- (void)disableRefreshButton
{
	self.refreshButton.enabled = NO;
}

- (IBAction)refreshButtonClicked:(id)sender {
    self.refreshNotiImageView.hidden = YES;
	self.refreshNotiImageShown = YES;
}

- (IBAction)commandCenterButtonClicked:(id)sender {
    self.commandCenterNotiImageView.hidden = YES;
}

- (IBAction)hideCommandCenterButtonClicked:(id)sender
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameHideCommandCenter object:nil];
}

- (IBAction)groupButtonClicked:(id)sender
{
    self.groupButton.selected = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameShowGroupChoice object:nil];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.optionsPopoverController = nil;
}


@end
