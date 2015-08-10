//
//  OAuthHelper.m
//  Demo
//
//  Created by mdevcon on 10/08/15.
//  Copyright (c) 2015 SURFnet. All rights reserved.
//

#import "OAuthHelper.h"
#import "AFNetworking.h"

#define SURFNET_BASEURL             @"https://nonweb.demo.surfconext.nl/php-oauth-as/authorize.php"
#define SURFNET_HTTP_CLIENT_ID      @"5dcbbc877e9955e3b29d7ca0baa4c7c4"
#define SURFNET_OAUTH_CLIENT_ID     @"4dca00da67c692296690e90c50c96b79"
#define SURFNET_OAUTH_RESPONSE_TYPE @"token"
#define SURFNET_OAUTH_SCOPE         @"authorize"
#define SURFNET_STATE               @"demo"

#define SURFNET_URL_FORMAT_STRING   @"%@?client_id=%@&response_type=%@&state=%@&scope=%@"

@interface OAuthHelper ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

static AuthenticationBlock authenticationBlock = nil;

@implementation OAuthHelper

- (id)init {
    self = [super init];
    if (self) {
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:SURFNET_BASEURL]];
        self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

#pragma mark OAuth authentication flow handling
+ (NSURL*)browserLoginUrlWithBlock:(AuthenticationBlock)block {
    authenticationBlock = [block copy];
    return [NSURL URLWithString: [NSString stringWithFormat: SURFNET_URL_FORMAT_STRING, SURFNET_BASEURL, SURFNET_OAUTH_CLIENT_ID, SURFNET_OAUTH_RESPONSE_TYPE, SURFNET_STATE, SURFNET_OAUTH_SCOPE]];
}

+ (BOOL)applicationOpenUrl:(NSURL*)url {
    if (authenticationBlock) {
        NSString *urlString = [url absoluteString];
        if ([urlString rangeOfString:@"#access_token="].location == NSNotFound) {
            // Unknown format
            return NO;
        }
        // Replace the weird hashtag with the correct question mark
        urlString = [urlString stringByReplacingOccurrencesOfString:@"#access_token=" withString:@"?access_token="];
        // Now we can parse it as an URL:
        NSURLComponents *urlComponents = [NSURLComponents componentsWithString:urlString];
        if (urlComponents.queryItems && urlComponents.queryItems.count > 0) {
            // First one is the access_token
            NSURLQueryItem *accessTokenItem = urlComponents.queryItems[0];
            if ([accessTokenItem.name isEqualToString:@"access_token"]) {
                // Just making it sure.
                if (authenticationBlock) {
                    authenticationBlock(accessTokenItem.value);
                    authenticationBlock = nil;
                    return YES;
                }
            }
        }
        return NO;
    } else {
        // Looks like the application was opened from an URL without starting the OAuth flow!
        return NO;
    }
}

@end
