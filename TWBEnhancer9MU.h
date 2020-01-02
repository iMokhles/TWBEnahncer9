//
//  TWBEnhancer9ListController.h
//  TWBEnhancer9
//
//  Created by iMokhles on 23.10.2015.
//  Copyright (c) 2015 iMokhles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#include <substrate.h>
#import <Accounts/Accounts.h>
#import "TWBEnhancer9DMImage.h"
#import "vendors/ImgurAnonymousAPIClient.h"
#import "progress/KVNProgress.h"

@protocol TWBEnhancer9MUDelegate <NSObject>
- (void)dismissMarkupViewController;
- (void)handleMarkupData:(NSData *)arg1 fileName:(NSString *)arg2 mimeType:(NSString *)arg3;
- (void)handleMarkupError:(NSError *)arg1;
- (void)handleMarkupURL:(NSURL *)arg1;
- (void)presentMarkupViewController:(UIViewController *)arg1;

@end

@interface TWBEnhancer9MU : NSObject
@property (nonatomic, strong) id <TWBEnhancer9MUDelegate> delegate;
+ (id)markupIcon;
- (id)initWithMarkupDelegate:(id)arg1;
@end
