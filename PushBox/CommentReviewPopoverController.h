//
//  CommentReviewPopoverController.h
//  PushBox
//
//  Created by Gabriel Yeah on 11-10-26.
//  Copyright (c) 2011年 同济大学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataViewController.h"
#import "DetailImageViewController.h"
#import "Status.h"

@interface CommentReviewPopoverController : CoreDataViewController<DetailImageViewControllerDelegate>
{
	UIImageView *_profileImageView;
	UILabel *_screenNameLabel;
	UILabel *_dateLabel;
	UIButton *_actionsButton;
	UIImageView *_tweetImageView;
	UILabel *_tweetTextLabel;
	UILabel *_repostTextLabel;
    UITextView *_postTextView;
    UITextView *_repostTextView;
    UIImageView *_repostBackgroundImageView;
    UIScrollView *_scrollView;

	UIView *_statusView;
	
	Status *_status;
}

@property(nonatomic, retain) IBOutlet UIImageView* profileImageView;
@property(nonatomic, retain) IBOutlet UILabel* screenNameLabel;
@property(nonatomic, retain) IBOutlet UILabel* dateLabel;
@property(nonatomic, retain) IBOutlet UIButton* actionsButton;
@property(nonatomic, retain) IBOutlet UIImageView* tweetImageView;
@property(nonatomic, retain) IBOutlet UILabel* tweetTextLabel;
@property(nonatomic, retain) IBOutlet UILabel* repostTextLabel;
@property(nonatomic, retain) IBOutlet UITextView* postTextView;
@property(nonatomic, retain) IBOutlet UITextView* repostTextView;
@property(nonatomic, retain) IBOutlet UIImageView* repostBackgroundImageView;
@property(nonatomic, retain) IBOutlet UIScrollView* scrollView;

@property(nonatomic, retain) IBOutlet UIView* statusView;

@property(nonatomic, retain) Status* status;

- (IBAction)dismissButtonClicked:(id)sender;
+(CommentReviewPopoverController*)sharedCommentReviewPopoverController;
- (IBAction)imageViewClicked:(UIGestureRecognizer *)ges;

@end
