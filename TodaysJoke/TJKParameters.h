//
//  TJKParameters.h
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 2/8/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CloudKit/CloudKit.h>

@interface TJKParameters : NSObject

#pragma Properties

@property (nonatomic, copy) NSString *contactUsEmail;
@property (nonatomic, copy) NSString *jokeSubmittedEmail;

#pragma Initializers
+(instancetype)initWithParameters:(NSString *)contactUsEmail
                  jokeSubmitted:(NSString *)jokeSubmittedEmail;


-(instancetype)initWithParameters:(NSString *)contactUsEmail
                    jokeSubmitted:(NSString *)jokeSubmittedEmail;

@end
