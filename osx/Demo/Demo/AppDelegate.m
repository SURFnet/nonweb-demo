//
//  AppDelegate.m
//  Demo
//
//  Created by Anthony Donker on 18/09/15.
//  Copyright © 2015 Surfnet. All rights reserved.
//

#import "AppDelegate.h"
#import "OAuthHelper.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-(void)applicationWillFinishLaunching:(NSNotification *)aNotification
{
    NSAppleEventManager *appleEventManager = [NSAppleEventManager sharedAppleEventManager];
    [appleEventManager setEventHandler:self
                           andSelector:@selector(handleGetURLEvent:withReplyEvent:)
                         forEventClass:kInternetEventClass andEventID:kAEGetURL];
}

- (void)handleGetURLEvent:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent {
    NSURL *url = [NSURL URLWithString:[[event paramDescriptorForKeyword:keyDirectObject] stringValue]];
    NSAlert *alert = [[NSAlert alloc] init];
    NSString *messageText;
    NSString *informativeText;
    if ([[OAuthHelper sharedInstance] applicationOpenUrl:url]) {
        messageText = NSLocalizedString(@"Got access token:", @"got access token");
        informativeText = [[OAuthHelper sharedInstance] lastRetrievedAccessToken];
    } else {
        messageText = NSLocalizedString(@"Invalid access", @"Invalid access");
        informativeText = NSLocalizedString(@"URL scheme was OK, but did not contain an access token", @"URL scheme was OK, but did not contain an access token");
        
    }
    alert.messageText = messageText;
    alert.informativeText = informativeText;
    [alert runModal];

    
}

@end
