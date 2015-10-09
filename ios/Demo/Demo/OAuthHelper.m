//
//  OAuthHelper.m
//  Demo
//
//  Created by mdevcon on 10/08/15.
//  Copyright (c) 2015 SURFnet. All rights reserved.
//

#import "OAuthHelper.h"
#import "WebViewController.h"

#define SURFNET_BASEURL             @"https://nonweb.demo.surfconext.nl/php-oauth-as/authorize.php"
#define SURFNET_HTTP_CLIENT_ID      @"5dcbbc877e9955e3b29d7ca0baa4c7c4"
#define SURFNET_OAUTH_CLIENT_ID     @"4dca00da67c692296690e90c50c96b79"
#define SURFNET_OAUTH_RESPONSE_TYPE @"token"
#define SURFNET_OAUTH_SCOPE         @"authorize"
#define SURFNET_STATE               @"demo"

#define SURFNET_URL_FORMAT_STRING   @"%@?client_id=%@&response_type=%@&state=%@&scope=%@"

@interface OAuthHelper ()

@property (nonatomic, copy) AuthenticationBlock authenticationBlock;
@property (nonatomic, weak) UIViewController *viewController;

@end



@implementation OAuthHelper

// Retrieves the singleton instace
+ (id)sharedInstance {
    static OAuthHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

// Initializes the singleton instance.
- (id)init {
    self = [super init];
    if (self) {}
    return self;
}

#pragma mark OAuth authentication flow handling

// Returns the authorization URL and stores the block.
// The block will be called when the application was opened from an URL, presumably because the login was successful.
- (NSURL*)authorizationUrlWithBlock:(AuthenticationBlock)block {
    self.authenticationBlock = block;
    return [NSURL URLWithString: [NSString stringWithFormat: SURFNET_URL_FORMAT_STRING, SURFNET_BASEURL, SURFNET_OAUTH_CLIENT_ID, SURFNET_OAUTH_RESPONSE_TYPE, SURFNET_STATE, SURFNET_OAUTH_SCOPE]];
}

// Starts the webview which will handle the authentication in itself.
// The block will be called on a successful login.
- (void)startWebViewAuthenticationFromController:(UIViewController*)controller withBlock:(AuthenticationBlock)block {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.viewController = [storyBoard instantiateViewControllerWithIdentifier:@"webViewController"];
    ((WebViewController *)self.viewController).requestUrl = [self authorizationUrlWithBlock:block];
    [controller presentViewController:self.viewController animated:YES completion:nil];
}

// Call this from the openUrl selector of your application. This function will parse the URL and retrieve the access
// token from it. A positive return value means that the access token has been retrieved.
- (BOOL)applicationOpenUrl:(NSURL*)url {
    if (self.viewController) {
        [self.viewController dismissViewControllerAnimated:YES completion:nil];
        self.viewController = nil;
    }
    if (self.authenticationBlock) {
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
                if (self.authenticationBlock) {
                    self.authenticationBlock(accessTokenItem.value);
                    self.authenticationBlock = nil;
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

// Starts the Safari View controller.
- (void)startSafariViewControllerAuthenticationFromController:(UIViewController*)controller withBlock:(AuthenticationBlock)block {
    NSURL *url = [self authorizationUrlWithBlock:block];
    SFSafariViewController *safariController = [[SFSafariViewController alloc] initWithURL: url];
    self.viewController = safariController;
    [controller presentViewController:safariController animated:YES completion:nil];
}

@end
