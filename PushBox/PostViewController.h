//
//  PostViewController.h
//  PushBox
//
//  Created by Xie Hasky on 11-7-30.
//  Copyright 2011年 同济大学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ErrorNotification.h"
#import "PostViewAtTableViewCell.h"
#import "EmotionsViewController.h"

#define kUserDefaultKeyAutoLocate @"kUserDefaultKeyAutoLocate"

typedef enum {
    PostViewTypePost,
    PostViewTypeRepost,
} PostViewType;

@class Status;

@interface PostViewController : UIViewController<UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, EmotionsViewControllerDelegate, CLLocationManagerDelegate> {
    UILabel *_titleLabel;
    UILabel *_wordsCountLabel;
    UIButton *_cancelButton;
    UIButton *_doneButton;
    UIButton *_referButton;
    UIButton *_topicButton;
    UIButton *_camaraButton;
    
    UIButton *_locationButton;
    UILabel *_lacationLabel;
    
    UITextView *_textView;
	
	UIImageView *_postingCircleImageView;
	UIImageView *_postingRoundImageView;
	
    UIView *_rightView;
    UIImageView *_rightImageView;
    
    UIView *_atView;
    UITableView *_atTableView;
    UITextField *_atTextField;
    
    EmotionsViewController *_emotionsViewController;
    UIView *_emotionsView;
//    UIView *_emotionsView;
//    UIScrollView *_emotionsScrollView;
//    UIPageControl *_emotionsPageControl;

    UIPopoverController *_pc;
    
    PostViewType _type;
    
    UIButton* _atBgButton;
    UIButton* _emotionBgButton;
    
    NSMutableArray *_atScreenNames;
    
    Status* _targetStatus;
    
    int textViewWordsCount;
    
    NSString* _lastChar;

    CLLocationManager* man;
}

@property(nonatomic, retain) IBOutlet UILabel* titleLabel;
@property(nonatomic, retain) IBOutlet UILabel* wordsCountLabel;
@property(nonatomic, retain) IBOutlet UIButton* cancelButton;
@property(nonatomic, retain) IBOutlet UIButton* doneButton;
@property(nonatomic, retain) IBOutlet UIButton* referButton;
@property(nonatomic, retain) IBOutlet UIButton* topicButton;
@property(nonatomic, retain) IBOutlet UIButton* camaraButton;
@property(nonatomic, retain) IBOutlet UIButton* locationButton;
@property(nonatomic, retain) IBOutlet UILabel* locationLabel;
@property(nonatomic, retain) IBOutlet UITextView* textView;
@property(nonatomic, retain) IBOutlet UIView* rightView;
@property(nonatomic, retain) IBOutlet UIView* atView;
@property(nonatomic, retain) IBOutlet UIView* emotionsView;
@property(nonatomic, retain) IBOutlet UITableView* atTableView;
@property(nonatomic, retain) IBOutlet UITextField* atTextField;

//@property(nonatomic, retain) IBOutlet UIView* emotionsView;
//@property(nonatomic, retain) IBOutlet UIScrollView* emotionsScrollView;
//@property(nonatomic, retain) IBOutlet UIPageControl* emotionsPageControl;

@property(nonatomic, retain) IBOutlet UIImageView* postingCircleImageView;
@property(nonatomic, retain) IBOutlet UIImageView* postingRoundImageView;

@property(nonatomic, retain) IBOutlet UIImageView* rightImageView;
@property(nonatomic, retain) UIPopoverController* pc;
@property(nonatomic, retain) Status *targetStatus;

@property(nonatomic, retain) NSMutableArray *atScreenNames;
 
- (id)initWithType:(PostViewType)type;
- (void)dismissView;

- (IBAction)cancelButtonClicked:(UIButton *)sender;
- (IBAction)doneButtonClicked:(id)sender;
- (IBAction)topicButtonClicked:(id)sender;
- (IBAction)camaraButtonClicked:(id)sender;
- (IBAction)atButtonClicked:(id)sender;
- (IBAction)emotionsButtonClicked:(id)sender;    
- (IBAction)removeImageButtonClicked:(id)sender;
- (IBAction)atTextFieldEditingChanged:(NSString*)text;
- (IBAction)atTextFieldEditingEnd;
- (IBAction)atTextFieldEditingBegan;

@end
