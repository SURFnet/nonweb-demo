//
//  OAuthHelper.h
//  Demo
//
//  Created by mdevcon on 10/08/15.
//  Copyright (c) 2015 SURFnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OAuthHelper : NSObject

typedef void (^AuthenticationBlock)(NSString *token);

+ (NSURL*)authorizationUrlWithBlock:(AuthenticationBlock)block;
+ (BOOL)applicationOpenUrl:(NSURL*)url;
+ (void)startWebViewAuthenticationFromController:(UIViewController*)viewController withBlock:(AuthenticationBlock)block;
@end
