//
//  TJKLeftPanelViewController.h
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 12/31/15.
//  Copyright © 2015 Glenn Seplowitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftPanelViewControllerDelegate <NSObject>

@optional
- (void)imageSelected:(UIImage *)image withTitle:(NSString *)imageTitle withCreator:(NSString *)imageCreator;

@required
- (void)textSelected:(NSString *)text;

@end

@interface TJKLeftPanelViewController : UIViewController 

@property (nonatomic, assign) id<LeftPanelViewControllerDelegate> delegate;

@end
