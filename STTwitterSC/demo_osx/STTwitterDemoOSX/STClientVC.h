//
//  STClientVC.h
//  STTwitterDemoOSX
//
//  Created by Nicolas Seriot on 9/22/13.
//  Copyright (c) 2013 Nicolas Seriot. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "STTwitter.h"

@interface STClientVC : NSViewController

@property (nonatomic, retain) STTwitterAPI *twitter;

@end
