//
//  OAuthHelper.h
//  Demo
//
//  Created by mdevcon on 10/08/15.
//  Copyright (c) 2015 SURFnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>


@interface OAuthHelper : NSObject

typedef void (^AuthenticationBlock)(NSString *token);

+ (id)sharedInstance;
- (NSURL*)authorizationUrlWithBlock:(AuthenticationBlock)block;
- (BOOL)applicationOpenUrl:(NSURL*)url;
- (void)startWebViewAuthenticationFromController:(UIViewController*)viewController withBlock:(AuthenticationBlock)block;
- (void)startSafariViewControllerAuthenticationFromController:(UIViewController*)controller withBlock:(AuthenticationBlock)block;
@end
