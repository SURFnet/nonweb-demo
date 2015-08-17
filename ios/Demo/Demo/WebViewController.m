//
//  WebViewController.m
//  Demo
//
//  Created by mdevcon on 10/08/15.
//  Copyright (c) 2015 SURFnet. All rights reserved.
//

#import "WebViewController.h"
#import "OAuthHelper.h"

@interface WebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.requestUrl];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
