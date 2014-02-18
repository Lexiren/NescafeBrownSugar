//
//  UIAlertView+NBSExtensions.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/2/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "UIAlertView+NBSExtensions.h"

@implementation UIAlertView (NBSExtensions)

+ (void)showSimpleAlertWithTitle:(NSString *)title message:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:title
                                message:message
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OKButton", nil)
                      otherButtonTitles:nil] show];
}

+ (void)showSimpleAlertWithTitle:(NSString *)title {
    [UIAlertView showSimpleAlertWithTitle:title message:nil];
}

+ (void)showSimpleAlertWithMessage:(NSString *)message {
    [UIAlertView showSimpleAlertWithTitle:nil message:message];
}

+ (void)showErrorAlertWithMessage:(NSString *)message {
    [UIAlertView showSimpleAlertWithTitle:NSLocalizedString(@"ErrorDisplayTitle", nil)
                                  message:message];
}

+ (void)showComingSoonAlert {
    [UIAlertView showSimpleAlertWithTitle:@"Under development." message:nil];
}

+ (void)showErrorAlertWithError:(NSError *)error
{
    if (error)
    {
        NSString *msg = nil;
        if ([error respondsToSelector:@selector(localizedDescription)]) {
            msg = [error localizedDescription];
        } else {
            msg = @"Виникла помилка пiд час передачi даних";
        }
        [UIAlertView showErrorAlertWithMessage:msg];
    }
}

@end
