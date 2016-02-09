//
//  TJKParameters.m
//  TodaysJoke
//
//  Created by Glenn Seplowitz on 2/8/16.
//  Copyright © 2016 Glenn Seplowitz. All rights reserved.
//

#import "TJKParameters.h"

@implementation TJKParameters

#pragma initializers

// desginated initializer
-(instancetype)initWithParameters:(NSString *)contactUsEmail
                    jokeSubmitted:(NSString *)jokeSubmittedEmail;
{
    self = [super init];
    
    if (self)
    {
        self.contactUsEmail= contactUsEmail;
        self.jokeSubmittedEmail = jokeSubmittedEmail;
    }
    
    return self;
}

// class level initializer
+(instancetype)initWithParameters:(NSString *)contactUsEmail
                    jokeSubmitted:(NSString *)jokeSubmittedEmail;
{
    TJKParameters *parameters = [[self alloc]initWithParameters:(NSString *)contactUsEmail jokeSubmitted:(NSString *)jokeSubmittedEmail];
    return parameters;
}

// override default initializer
-(instancetype)init
{
    return [self initWithParameters:@"" jokeSubmitted:@""];
}

@end
