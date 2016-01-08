//
//  TJKDetailJokeViewController.h
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 12/19/15.
//  Copyright © 2015 Glenn Seplowitz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class TJKJokeItem;

@interface TJKDetailJokeViewController : UIViewController <MFMailComposeViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
{
    MFMailComposeViewController *mailComposer;
}

-(instancetype)initForNewItem:(BOOL)isNew;
@property (nonatomic, strong) TJKJokeItem *jokeItem;

@end
