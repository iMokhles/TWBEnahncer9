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
#import <AVFoundation/AVFoundation.h>
#import "TWBEnhancer9DMImage.h"
#import "vendors/ImgurAnonymousAPIClient.h"
#import "progress/KVNProgress.h"
#import "TWBEnhancer9Font.h"
#import "vendors/SBKTextView.h"

typedef void (^lastImageDataBlock)(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info);

@class MarkupViewController;

@interface MUImageContentViewController : UIViewController 
@property (nonatomic, retain) UIImageView *imageView;
- (void)setImage:(id)arg1;
@end

typedef void(^MarkupFinishedWithImage)(MarkupViewController *mkUI, UIImage *image);
typedef void(^MarkupCancelBlock)(MarkupViewController *mkUI);

@interface MarkupViewController : UIViewController
@property (retain) MUImageContentViewController *contentViewController;
@property (copy, nonatomic) MarkupFinishedWithImage imageBlock;
@property (copy, nonatomic) MarkupCancelBlock cancelBlock;
- (BOOL)writeToURL:(id)arg1 error:(id)arg2;
- (void)setFileURL:(id)arg1;
- (void)setImage:(id)arg1;
- (void)setData:(id)arg1;
- (void)setDelegate:(id)arg1;
- (void)setAllowShakeToUndo:(BOOL)arg1;
- (void)setNavBar:(id)arg1;
- (void)_createCancelDoneNavBar;
@end

@interface PTHStaticSectionCell : UIControl
@property(copy, nonatomic) NSString *detailText;
@property(copy, nonatomic) NSString *text;
@property(retain, nonatomic) UIImage *image;
@property(nonatomic, getter=isOn) _Bool on;
- (id)initWithType:(long long)arg1;
- (id)initWithType:(long long)arg1 colorGroupName:(id)arg2;
- (void)setHighlighted:(_Bool)arg1;
- (void)setSelected:(_Bool)arg1;
- (void)setEnabled:(_Bool)arg1;
- (void)_valueChanged;
- (void)setOn:(_Bool)arg1 animated:(_Bool)arg2;
@end

@interface PTHStaticSectionView : UIControl
@property(copy, nonatomic) NSString *headerTitle;
- (_Bool)isCellHidden:(id)arg1;
- (void)showCell:(id)arg1;
- (void)hideCell:(id)arg1;
- (void)addCell:(id)arg1;
- (void)setEnabled:(_Bool)arg1;
- (id)initWithFrame:(CGRect)arg1;
- (id)initWithColorGroupName:(id)arg1;
+ (void)initialize;
@end

@interface PTHTweetbotSettingsController : PTHViewController 
@end

@interface PTHTweetbotDeveloperSettingsController : PTHViewController
@end

@interface PTHTweetbotStreamingSettingsController : PTHViewController
@end

@interface PTHTweetbotCursorController : PTHViewController
- (id)initWithTweetbotCursor:(id)arg1;
@end

@interface PTHTweetbotStatusFavoritesController : PTHTweetbotCursorController
- (id)initWithStatus:(id)arg1;
@end

@interface PTHTweetbotStatusDetailChildController : PTHViewController
@property(readonly, nonatomic) PTHTweetbotStatus *status; // @synthesize status=_status;
@end


@interface PTHTweetbotStatusDetailActionController : PTHTweetbotStatusDetailChildController
- (void)_showRetweets:(id)arg1;
- (void)_showFavorites:(id)arg1;
@end

@interface PTHTweetbotMediumImageView : UIScrollView
@property(nonatomic) __weak UIViewController *controller; // @synthesize controller=_controller;
@end

@interface PTHTweetbotStatusDetailController : PTHViewController
@property(readonly, nonatomic) PTHTweetbotStatus *status; // @synthesize status=_status;
@end

@interface PTHTweetbotPostDraftsController : PTHViewController
@end

@interface PTHTweetbotPostController : PTHViewController
@property(retain, nonatomic) PTHTweetbotPostDraft *draft; // @synthesize draft=_draft;
@end

@interface PTHAlertController : PTHViewController
@property(copy, nonatomic) NSString *title; // @dynamic title;
@property(copy, nonatomic, setter=setOKButtonTitle:) NSString *okButtonTitle; // @synthesize okButtonTitle=_okButtonTitle;
@property(copy, nonatomic) NSString *message; // @synthesize message=_message;
@property(copy, nonatomic) NSString *cancelButtonTitle; // @synthesize cancelButtonTitle=_cancelButtonTitle;

//actions
@property(copy, nonatomic) id didOKBlock; // @synthesize didOKBlock=_didOKBlock;
@property(copy, nonatomic) id didCancelBlock; // @synthesize didCancelBlock=_didCancelBlock;
@end

@interface PTHTweetbotMediaController : PTHViewController
@end

@interface AVPlayerInternal : NSObject {
	AVPlayerItem *currentItem;
}
@end

@interface _PTHSteppedSlider : UISlider
@end

@interface PTHTweetbotSettings : NSObject
+ (id)sharedSettings;
@property(nonatomic, getter=isStreamingEnabled) _Bool streamingEnabled; // @synthesize streamingEnabled=_streamingEnabled;
@property(nonatomic, getter=isStreamingOverWWANEnabled) _Bool streamingOverWWANEnabled; // @synthesize streamingOverWWANEnabled=_streamingOverWWANEnabled;
@end

// @interface NSUserDefaults ()
// - (void)setBool:(BOOL)arg1 forKey:(id)arg2;
// @end

@interface TWBEnhancer9Helper : NSObject

// Preferences
+ (NSString *)preferencesPath;
+ (CFStringRef)preferencesChanged;
// bundle 
+ (NSBundle *)twbenhancer9_bundle;

// UIWindow to present your elements
// u can show/hide it using ( setHidden: NO/YES )
+ (UIWindow *)mainTWBEnhancer9Window;
+ (UIViewController *)mainTWBEnhancer9ViewController;

// Checking App Version
+ (BOOL)isAppVersionGreaterThanOrEqualTo:(NSString *)appversion;
+ (BOOL)isAppVersionLessThanOrEqualTo:(NSString *)appversion;

// Checking OS Version
+ (BOOL)isIOS83_OrGreater;
+ (BOOL)isIOS80_OrGreater;
+ (BOOL)isIOS70_OrGreater;
+ (BOOL)isIOS60_OrGreater;
+ (BOOL)isIOS50_OrGreater;
+ (BOOL)isIOS40_OrGreater;

// Checking Device Type
+ (BOOL)isIPhone6_Plus;
+ (BOOL)isIPhone6;
+ (BOOL)isIPhone5;
+ (BOOL)isIPhone4_OrLess;

// Checking Device Interface
+ (BOOL)isIPad;
+ (BOOL)isIPhone;

// Checking Device Retina
+ (BOOL)isRetina;

// Checking UIScreen sizes
+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;

+ (PHAsset *)lastTakenAsset;
+ (UIImage *)lastTakenImage;
+ (UIImage *)screenshotForView:(UIView *)view;
+ (CGFloat)heightForText:(NSString*)bodyText withFont:(UIFont *)textFont;
+ (UIImage *)imageFromText:(NSString *)text font:(FontName)fontName fontSize:(CGFloat)fontSize imageSize:(CGSize)imageSize;
+ (void)lastImageData:(lastImageDataBlock)lastBlock;
+ (void)sendImage:(UIImage *)image toUserID:(NSString *)userID;
+ (NSArray *)splitString:(NSString*)str maxCharacters:(NSInteger)maxLength;
@end


// enableDMCamKey
// enableStreamLTE
// enableFavbot
// enableEditImage
// enableShareTweet
// enableDeletaDrafts
// enableImagePost
// enableDownloadVideo
