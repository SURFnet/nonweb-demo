//
//  OAuthHelper.h
//  Demo
//
//  Created by mdevcon on 10/08/15.
//  Copyright (c) 2015 SURFnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OAuthHelper : NSObject

typedef void (^AuthenticationBlock)(NSString *token);

+ (NSURL*)browserLoginUrlWithBlock:(AuthenticationBlock)block;
+ (BOOL)applicationOpenUrl:(NSURL*)url;
@end
