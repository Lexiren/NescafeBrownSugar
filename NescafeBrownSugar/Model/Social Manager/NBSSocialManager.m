//
//  NBSSocialManager.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/2/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSSocialManager.h"
#import <Instagram.h>

#define kNBSInstagramAppIDPlistKey @"InstagramAppID"

@interface NBSSocialManager () //<IGSessionDelegate>

//instagram
@property (nonatomic, strong) NSString *instagramAppID;
@property (nonatomic, strong) Instagram *instagram;
@property (nonatomic, copy) NBSCompletionBlock instagramLoginCompletion;

@end

@implementation NBSSocialManager

#pragma mark - init
+ (NBSSocialManager *)sharedManager {
    static NBSSocialManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [NBSSocialManager new];
    });
    return sharedInstance;
}
/*
#pragma mark - lazy initialization
- (NSString *)instagramAppID {
    if (!_instagramAppID) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        _instagramAppID = [infoDictionary objectForKey:kNBSInstagramAppIDPlistKey];
        NSAssert(_instagramAppID, @"Failed to read %@ string from Info.plist. It should be specified there.", kNBSInstagramAppIDPlistKey);
    }
    return _instagramAppID;
}

- (Instagram *)instagram {
    if (!_instagram) {
        _instagram = [[Instagram alloc] initWithClientId:self.instagramAppID delegate:self];
    }
    return _instagram;
}*/

#pragma mark - login
- (void)instagramLoginWithCompletion:(NBSCompletionBlock)completion {
    
}
/*
#pragma mark - IGSessionDelegate
-(void)igDidLogin {
    DLog(@"Instagram did login");
 
    // here i can get and store instagramAccessToken
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.instagram.accessToken forKey:@"accessToken"];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
    IGListViewController* viewController = [[IGListViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    if (self.instagramLoginCompletion) {
        self.instagramLoginCompletion(YES, nil);
    }
}

-(void)igDidNotLogin:(BOOL)cancelled {
    NSLog(@"Instagram did not login");
    NSString* message = nil;
    if (cancelled) {
        message = @"Access cancelled!";
    } else {
        message = @"Access denied!";
    }
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

-(void)igDidLogout {
    NSLog(@"Instagram did logout");
    // remove the accessToken
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"accessToken"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)igSessionInvalidated {
    NSLog(@"Instagram session was invalidated");
}
*/
@end
