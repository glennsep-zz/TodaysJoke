//
//  TJKDetailJokeViewController.h
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 12/19/15.
//  Copyright © 2015 Glenn Seplowitz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Parse/Parse.h>
#import "TJKConstants.h"


@interface TJKDetailJokeViewController : UIViewController <MFMailComposeViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
{
    #pragma Setup Mail view Controller
    MFMailComposeViewController *mailComposer;
}

@end
