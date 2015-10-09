//
//  WebViewController.m
//  Demo
//
//  Created by Anthony Donker on 18/09/15.
//  Copyright © 2015 Surfnet. All rights reserved.
//

#import "WebViewController.h"
#import "OAuthHelper.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()
@property (strong) IBOutlet WebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSurfnetPage];
}

- (void)loadSurfnetPage {
    NSURL *url = [[OAuthHelper sharedInstance] authorizationUrlWithBlock:^(NSString *token) {
        [self dismissController:nil];
    }];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [[[self webView] mainFrame] loadRequest:urlRequest];
}
@end
