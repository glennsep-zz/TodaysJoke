//
//  TJKConstants.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 1/28/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import "TJKConstants.h"

// assign values to constants
// custom container
NSString *const JOKE_CONTAINER = @"iCloud.com.glennseplowitz.Jokes";

// used when selecting categories
NSString *const DEFAULT_CATEGORY = @"Select a Category...";
NSString *const LOADING_CATEGORY = @"Loading Categories...";

// category record types and fields
NSString *const CATEGORY_RECORD_TYPE = @"Categories";
NSString *const CATEGORY_FIELD_NAME = @"CategoryName";
NSString *const CATEGORY_FIELD_IMAGE = @"CategoryImage";
NSString *const CATEGORY_FIELD_FAVORITE = @"Favorites";
NSString *const CATEGORY_TO_REMOVE_OTHER = @"Other";
NSString *const CATEGORY_TO_REMOVE_RANDOM = @"Random";
NSString *const CATEGORY_TO_REMOVE_FAVORITE = @"Favorites";
NSString *const CATEGORY_ALL = @"All";

// joke record types and fields
NSString *const JOKE_RECORD_TYPE = @"Jokes";
NSString *const JOKE_DESCR = @"jokeDescr";
NSString *const JOKE_SUBMITTED_BY = @"jokeSubmittedBy";
NSString *const JOKE_TITLE = @"jokeTitle";
NSString *const JOKE_CREATED = @"jokeDisplayDate";

// generic parameters
NSString *const PARAMETERS_RECORD_TYPE = @"Parameters";
NSString *const PARAMETERS_CATEGORY_RECORD_NAME = @"7862f17b-a3de-4f3c-83ad-19e997bdf7f4";
NSString *const PARAMETERS_JOKE_SUBMITTED_EMAIL = @"jokeSubmittedEMail";
NSString *const PARAMETERS_CONTACT_US_EMAIL = @"contactUsEmail";

// fonts
NSString *const FONT_NAME = @"Marker Felt";
CGFloat  const FONT_SIZE = 22.0f;

// cache list names
NSString *const CACHE_CATEGORY_LIST = @"ListCategories";
NSString *const CACHE_CATEGORY_PICKER = @"ListCategoryPicker";

// file name to store favorite jokes
NSString *const FILE_NAME_FAVORITES = @"favorites.archive";