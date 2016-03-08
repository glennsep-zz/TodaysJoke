//
//  TJKConstants.h
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 1/24/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import <UIKit/UIKit.h>

// declare constants
// custom container
extern NSString *const JOKE_CONTAINER;

// used when selecting categories
extern NSString *const DEFAULT_CATEGORY;
extern NSString *const LOADING_CATEGORY;

// category record types and fields
extern NSString *const CATEGORY_RECORD_TYPE;
extern NSString *const CATEGORY_FIELD_NAME;
extern NSString *const CATEGORY_FIELD_IMAGE;
extern NSString *const CATEGORY_TO_REMOVE_OTHER;
extern NSString *const CATEGORY_TO_REMOVE_RANDOM;

// joke record types and fields
extern NSString *const JOKE_RECORD_TYPE;
extern NSString *const JOKE_DESCR;
extern NSString *const JOKE_SUBMITTED_BY;
extern NSString *const JOKE_TITLE;
extern NSString *const JOKE_CREATED;

// generic parameters
extern NSString *const PARAMETERS_RECORD_TYPE;
extern NSString *const PARAMETERS_CATEGORY_RECORD_NAME;
extern NSString *const PARAMETERS_JOKE_SUBMITTED_EMAIL;
extern NSString *const PARAMETERS_CONTACT_US_EMAIL;

// fonts
extern NSString *const FONT_NAME;
extern CGFloat   const FONT_SIZE;

// cache list names
extern NSString *const CACHE_CATEGORY_LIST;
extern NSString *const CACHE_CATEGORY_PICKER;