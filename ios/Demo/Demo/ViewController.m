//
//  ViewController.m
//  Demo
//
//  Created by mdevcon on 10/08/15.
//  Copyright (c) 2015 SURFnet. All rights reserved.
//

#import "ViewController.h"
#import "OAuthHelper.h"
#import "WebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Called when the user selected the browser login
- (IBAction)browserLoginTouchUpInside:(id)sender {
    [[UIApplication sharedApplication] openURL:[OAuthHelper authorizationUrlWithBlock:^(NSString *token) {
        [self displayToken:token];
    }]];
}

// Called when the user selected the in-app login
- (IBAction)inAppLoginTouchUpInside:(id)sender {
    [OAuthHelper startWebViewAuthenticationFromController:self withBlock:^(NSString *token) {
        [self displayToken:token];
    }];
}

// Displays the access token in a simple alert window.
- (void)displayToken:(NSString*)token {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Access token"
                                                    message:[NSString stringWithFormat:@"Access token is: %@", token]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

@end
