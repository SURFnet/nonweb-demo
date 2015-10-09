//
//  ViewController.m
//  Demo
//
//  Created by Anthony Donker on 18/09/15.
//  Copyright © 2015 Surfnet. All rights reserved.
//

#import "ViewController.h"
#import "OAuthHelper.h"
#import <WebKit/WebKit.h>

@interface ViewController()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

// open a sheet with a WebView
- (IBAction)openWebViewController:(id)sender {
    [self performSegueWithIdentifier:@"openWebViewController" sender:self];
    
}

// Open the user's default browser
- (IBAction)openBrowser:(id)sender {
    NSURL *url = [[OAuthHelper sharedInstance] authorizationUrlWithBlock:nil];
    [[NSWorkspace sharedWorkspace] openURL:url];
}

@end
