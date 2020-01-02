//
//  TWBEnhancer9ListController.m
//  TWBEnhancer9
//
//  Created by iMokhles on 23.10.2015.
//  Copyright (c) 2015 iMokhles. All rights reserved.
//

#import "TWBEnhancer9Helper.h"

@implementation TWBEnhancer9Helper

// Preferences
+ (NSString *)preferencesPath {
	return @"/User/Library/Preferences/com.imokhles.twbenhancer9.plist";
}

+ (CFStringRef)preferencesChanged {
	return (__bridge CFStringRef)@"com.imokhles.twbenhancer9.preferences-changed";
}

// bundle 
+ (NSBundle *)twbenhancer9_bundle {
	return [NSBundle bundleWithPath:@"/Library/Application Support/TWBEnhancer9"];
}

// UIWindow to present your elements
// u can show/hide it using ( setHidden: NO/YES )
+ (UIWindow *)mainTWBEnhancer9Window {
	return nil;
}

+ (UIViewController *)mainTWBEnhancer9ViewController {
	return nil;
}

// Checking App Version
+ (BOOL)isAppVersionGreaterThanOrEqualTo:(NSString *)appversion {
	return [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] compare:appversion options:NSNumericSearch] != NSOrderedAscending;
}
+ (BOOL)isAppVersionLessThanOrEqualTo:(NSString *)appversion {
	return [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] compare:appversion options:NSNumericSearch] != NSOrderedDescending;
}

// Checking OS Version
+ (BOOL)isIOS83_OrGreater {
	return [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.3;
}
+ (BOOL)isIOS80_OrGreater {
	return [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0;
}
+ (BOOL)isIOS70_OrGreater {
	return [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
}
+ (BOOL)isIOS60_OrGreater {
	return [[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0;
}
+ (BOOL)isIOS50_OrGreater {
	return [[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0;
}
+ (BOOL)isIOS40_OrGreater {
	return [[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0;
}

// Checking Device Type
+ (BOOL)isIPhone6_Plus {
	return [self isIPhone] && [self screenMaxLength] == 736.0;
}
+ (BOOL)isIPhone6 {
	return [self isIPhone] && [self screenMaxLength] == 667.0;
}
+ (BOOL)isIPhone5 {
	return [self isIPhone] && [self screenMaxLength] == 568.0;
}
+ (BOOL)isIPhone4_OrLess {
	return [self isIPhone] && [self screenMaxLength] < 568.0;
}

// Checking Device Interface
+ (BOOL)isIPad {
	return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}
+ (BOOL)isIPhone {
	return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
}

// Checking Device Retina
+ (BOOL)isRetina {
	if ([self isIOS80_OrGreater]) {
        return [UIScreen mainScreen].nativeScale>=2;
    }
	return [[UIScreen mainScreen] scale] >= 2.0;
}

// Checking UIScreen sizes
+ (CGFloat)screenWidth {
	return [[UIScreen mainScreen] bounds].size.width;
}
+ (CGFloat)screenHeight {
	return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGFloat)screenMaxLength {
    return MAX([self screenWidth], [self screenHeight]);
}

+ (CGFloat)screenMinLength {
    return MIN([self screenWidth], [self screenHeight]);
}

+ (UIImage *)lastTakenImage {
	__block UIImage *lastImage = nil;

    [[PHImageManager defaultManager] requestImageDataForAsset:[self lastTakenAsset] options:PHImageRequestOptionsVersionCurrent resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        if (imageData) {
            lastImage = [UIImage imageWithData:imageData];
        }
    }];
    return lastImage;
}

+ (PHAsset *)lastTakenAsset {
	PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    PHAsset *lastAsset = [fetchResult lastObject];

    return lastAsset;
}

+ (void)lastImageData:(lastImageDataBlock)lastBlock {
	__block NSData *imageData = nil;
	PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    PHAsset *lastAsset = [fetchResult lastObject];
	[[PHImageManager defaultManager] requestImageDataForAsset:lastAsset options:PHImageRequestOptionsVersionCurrent resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        lastBlock(imageData, dataUTI, orientation, info);
    }];
}
+ (void)sendImage:(UIImage *)image toUserID:(NSString *)userID {

}

+ (UIImage *)screenshotForView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImagePNGRepresentation(image);
    image = [UIImage imageWithData:imageData];
    
    return image;
}

+ (UIImage *)imageFromText:(NSString *)text font:(FontName)fontName fontSize:(CGFloat)fontSize imageSize:(CGSize)imageSize
{
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	[paragraphStyle setAlignment:NSTextAlignmentCenter];

    [text drawAtPoint:CGPointMake(0.0, 0.0) withAttributes:@{NSFontAttributeName:[UIFont fontForFontName:fontName size:fontSize], NSParagraphStyleAttributeName:paragraphStyle}];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (CGFloat)heightForText:(NSString*)bodyText withFont:(UIFont *)textFont
{
    float width = bodyText.length*10;
    UIFont *cellFont = textFont; //[UIFont fontWithName:@"Arial" size:14];
    CGSize constraintSize = CGSizeMake(width, MAXFLOAT);
    if (width > [UIScreen mainScreen].bounds.size.width) {
        constraintSize = CGSizeMake(310, MAXFLOAT);
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:bodyText];
    //Add LineBreakMode
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [attributedString setAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, attributedString.length)];
    // Add Font
    [attributedString setAttributes:@{NSFontAttributeName:cellFont} range:NSMakeRange(0, attributedString.length)];
    
    //Now let's make the Bounding Rect
    CGSize labelSize = [attributedString boundingRectWithSize:constraintSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    CGFloat height = labelSize.height + 10;
    return height;
}

+ (NSArray *)splitString:(NSString*)str maxCharacters:(NSInteger)maxLength {    
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:1];
    NSArray *wordArray = [str componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSInteger numberOfWords = [wordArray count];
    NSInteger index = 0;
    NSInteger lengthOfNextWord = 0;
    
	while (index < numberOfWords) {
		NSMutableString *line = [NSMutableString stringWithCapacity:1];
		while ((([line length] + lengthOfNextWord + 1) <= maxLength) && (index < numberOfWords)) {
			[line appendString:[wordArray objectAtIndex:index]];
			index++;
			if (index < numberOfWords) {
				[line appendString:@" "];
				lengthOfNextWord = [[wordArray objectAtIndex:index] length];
			}
		}
		[tempArray addObject:line];
	}
    return tempArray;
}
@end
