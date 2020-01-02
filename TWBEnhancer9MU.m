//
//  TWBEnhancer9ListController.m
//  TWBEnhancer9
//
//  Created by iMokhles on 23.10.2015.
//  Copyright (c) 2015 iMokhles. All rights reserved.
//

#import "TWBEnhancer9MU.h"
#import <UIKit/UIImage2.h>

Class twb_initAKController() {
	static dispatch_once_t token = 0;
	dispatch_once(&token, ^{
		void *la = dlopen("/System/Library/PrivateFrameworks/AnnotationKit.framework/AnnotationKit", RTLD_LAZY);
		if ((char *)la == nil) {
			NSLog(@"### Failed to Soft Linked: /System/Library/PrivateFrameworks/AnnotationKit.framework/AnnotationKit");
		}
	});
	return objc_getClass("AKController");
}

@implementation TWBEnhancer9MU
+ (UIImage *)markupIcon {
	return [UIImage imageNamed:@"PlugIns/Markup.appex/AppIcon60x60" inBundle:[NSBundle bundleForClass:twb_initAKController()]];
}

- (id)initWithMarkupDelegate:(id)arg1 {
	if (self = [super init]) {
		[self setDelegate:arg1];
	}
	return self;
}

@end
