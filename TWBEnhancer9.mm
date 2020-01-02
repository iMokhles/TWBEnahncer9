//
//  TWBEnhancer9.x
//  TWBEnhancer9
//
//  Created by iMokhles on 23.10.2015.
//  Copyright (c) 2015 iMokhles. All rights reserved.
//

#import "TWBEnhancer9Helper.h"
#import <libimodevtools2/iMoDevTools2Own.h>

BOOL isTweakEnabled;
static void TWBEnhancer9_Prefs() {
	NSDictionary *TWBEnhancer9Settings = [NSDictionary dictionaryWithContentsOfFile:[TWBEnhancer9Helper preferencesPath]];
	NSNumber *isTweakEnabledNU = TWBEnhancer9Settings[@"isTweakEnabled"];
    isTweakEnabled = isTweakEnabledNU ? [isTweakEnabledNU boolValue] : 0;
}

BOOL didShowWelcomeScreen = NO;
#define TWEAK_SETTINGS @"com.imokhles.twbenhancer9"

typedef void (^accountChooserBlock_t)(ACAccount *account, NSString *errorMessage);

%group main
static  STTwitterAPI *twitter;
static  ACAccountStore *accountStore;
static  NSArray *iOSAccounts;
static  accountChooserBlock_t accountChooserBlock;
static  PTHTweetbotDirectMessageThread *directMessageThread;
static  PTHTweetbotUser *mainToUser;
static  NSString *consumerKey;
static  NSString *consumerSecret;
static  UIBarButtonItem *camBtn;
static ImgurAnonymousAPIClient *imgrClient;
static KVNProgressConfiguration *basicConfiguration;
static UIBarButtonItem *deleteButton;
static PTHStaticSectionCell *lteCell;
static PTHTweetbotAccount *currentAccount;
static NSString *originalVideoStatusID;

// static BOOL isStatusDetail = NO;
__attribute__((always_inline, visibility("hidden")))
static void size_reallocing() {
    [[iMoDevTools sharedInstance] checkOutSide:@"com.imokhles.twbenhancer" withBlock:^(NSString *string) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([string isEqualToString:@"Cracked"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc] initWithTitle:@"TWBEnhancer9" message:[NSString stringWithFormat:@"I couldn't verify your license, please be sure that you bought me, if you need to test before buying, check TWBEnhancer9 Lite from Cydia\nSomething Wrong"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                });
                [[iMoDevTools sharedInstance] removeThisThing:@"TWBEnhancer9"];
            }
        });
    }];
}

%hook PTHTweetbotAppDelegate
- (void)applicationDidBecomeActive:(id)arg1 {
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    ACAccountStoreRequestAccessCompletionHandler accountStoreRequestCompletionHandler = ^(BOOL granted, NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            if(granted == NO) {
                accountChooserBlock(nil, @"Acccess not granted.");
                return;
            }
            
            iOSAccounts = [accountStore accountsWithAccountType:accountType];
            
            if([iOSAccounts count] == 1) {
                ACAccount *account = [iOSAccounts lastObject];
                twitter = [STTwitterAPI twitterAPIOSWithAccount:account delegate:self];
                
                [twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
                    
                    NSLog(@"@%@ (%@)", username, userID);
                } errorBlock:^(NSError *error) {
                    NSLog(@"Error: (%@)", [error localizedDescription]);
                }];
            } else {
                for(ACAccount *account in iOSAccounts) {
                    for (PTHTweetbotAccount *accountTWB in [%c(PTHTweetbotAccount) accounts]) {
                        if ([account.username isEqualToString:accountTWB.currentUser.screenName]) {
                            twitter = [STTwitterAPI twitterAPIOSWithAccount:account delegate:self];
                            
                            [twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
                                
                                NSLog(@"@%@ (%@)", username, userID);
                            } errorBlock:^(NSError *error) {
                                NSLog(@"Error: (%@)", [error localizedDescription]);
                            }];
                            break;
                        }
                    }
                    
                }
            }
        }];
    };
    %orig;
}
%end

%hook PTHTweetbotDirectMessageThreadsController
- (id)initWithAccount:(PTHTweetbotAccount *)account {
    currentAccount = account;
    return %orig;
}
%end

%hook PTHTweetbotDirectMessagesController

- (void)viewDidLoad
{
    size_reallocing();
    directMessageThread = MSHookIvar<PTHTweetbotDirectMessageThread *>(self, "_directMessageThread");
    mainToUser = directMessageThread.otherUser;
    imgrClient = [[ImgurAnonymousAPIClient alloc] initWithClientID:@"d50413b4f29e4f0"];
	%orig;
	accountStore = [[ACAccountStore alloc] init];
	consumerKey = @"j9s7DQQWZJR77gGACLxpzVHOf";
    consumerSecret = @"MjdTGSGrunMCBBouQmg737FZ3ciFGYV7nJ0VrhfYNX1bDBg1t6";
    [self performSelector:@selector(setupHUDView)];
}
- (void)viewWillAppear:(BOOL)arg1 {
	%orig;
	UIBarButtonItem *origShareBtn = [self navigationItem].rightBarButtonItem;
	camBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(twb_sendImage)];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"enableDMCamKey"] == YES) {
        if (origShareBtn) {
            [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:origShareBtn, camBtn, nil]];
        } else {
            [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:camBtn, nil]];
        }
    } else {
        if (origShareBtn) {
            [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:origShareBtn, nil]];
        } else {
            [self.navigationItem setRightBarButtonItems:nil];
        }
    }
}

%new
- (void)setupHUDView {
    basicConfiguration = [KVNProgressConfiguration defaultConfiguration];
    basicConfiguration.fullScreen = YES;
}

- (void)viewDidAppear:(BOOL)arg1 {
    [KVNProgress setConfiguration:basicConfiguration];
	%orig;
	__weak PTHTweetbotDirectMessagesController *weakSelf = self;
    
    accountChooserBlock = ^(ACAccount *account, NSString *errorMessage) {
        
        NSString *status = nil;
        if(account) {
            status = [NSString stringWithFormat:@"Did select %@", account.username];
            
            [weakSelf loginWithiOSAccount:account];
        } else {
            status = errorMessage;
        }
        NSLog(@"******* Status: %@", status);
    };
    [self chooseAccount];
}
%new
- (void)loginWithiOSAccount:(ACAccount *)account {
    
//    twitter = nil;
    twitter = [STTwitterAPI twitterAPIOSWithAccount:account delegate:self];
    
    [twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        
         NSLog(@"@%@ (%@)", username, userID);
    } errorBlock:^(NSError *error) {
        NSLog(@"Error: (%@)", [error localizedDescription]);
    }];
    
}
%new
- (void)chooseAccount {
    
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    ACAccountStoreRequestAccessCompletionHandler accountStoreRequestCompletionHandler = ^(BOOL granted, NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            if(granted == NO) {
                accountChooserBlock(nil, @"Acccess not granted.");
                return;
            }
            
            iOSAccounts = [accountStore accountsWithAccountType:accountType];
            
            if([iOSAccounts count] == 1) {
                ACAccount *account = [iOSAccounts lastObject];
                accountChooserBlock(account, nil);
            } else {
//                UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"Select an account:"
//                                                                delegate:self
//                                                       cancelButtonTitle:@"Cancel"
//                                                  destructiveButtonTitle:nil otherButtonTitles:nil];
                for(ACAccount *account in iOSAccounts) {
                    if ([account.username isEqualToString:currentAccount.currentUser.screenName]) {
                        accountChooserBlock(account, nil);
                        break;
                    }
//                    else {
//                        [as addButtonWithTitle:[NSString stringWithFormat:@"@%@", account.username]];
//                    }
                    
                }
//                [as showInView:self.view.window];
            }
        }];
    };
    
#if TARGET_OS_IPHONE &&  (__IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0)
    if (floor(NSFoundationVersionNumber) < NSFoundationVersionNumber_iOS_6_0) {
        [accountStore requestAccessToAccountsWithType:accountType
                                     withCompletionHandler:accountStoreRequestCompletionHandler];
    } else {
        [accountStore requestAccessToAccountsWithType:accountType
                                                   options:NULL
                                                completion:accountStoreRequestCompletionHandler];
    }
#else
    [accountStore requestAccessToAccountsWithType:accountType
                                               options:NULL
                                            completion:accountStoreRequestCompletionHandler];
#endif

}

%new
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == [actionSheet cancelButtonIndex]) {
        accountChooserBlock(nil, @"Account selection was cancelled.");
        return;
    }
    
    NSUInteger accountIndex = buttonIndex - 1;
    ACAccount *account = [iOSAccounts objectAtIndex:accountIndex];
    
    accountChooserBlock(account, nil);
}
%new
- (void)twb_sendImage {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"enableDMCamKey"] == NO) {
        return;
    }
    PTHActionSheet *actionSheet = [[%c(PTHActionSheet) alloc] init];
    [actionSheet addActionButton:@"Last Taken Image" selectBlock:^{
        [TWBEnhancer9Helper lastImageData:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info){
            if (imageData) {
                [self performSelector:@selector(twb_sendImageData:) withObject:imageData];
            }
        }];
    }];
    [actionSheet addActionButton:[[NSBundle mainBundle] localizedStringForKey:@"Image from Library" value:@"" table:0x0] selectBlock:^{
        [self sendImageFromSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    [actionSheet addActionButton:[[NSBundle mainBundle] localizedStringForKey:@"Image from Camera" value:@"" table:0x0] selectBlock:^{
        [self sendImageFromSourceType:UIImagePickerControllerSourceTypeCamera];
    }];
    PTHTweetbotShowDelegate *showDelegate = [[%c(PTHTweetbotShowDelegate) alloc] init];
    [showDelegate setBarButtonItem:camBtn];
    [showDelegate setPresentOptions:0x1000];
    [showDelegate setSourceObject:directMessageThread];
    [self presentActionSheet:actionSheet delegate:showDelegate completion:0x0];
}

%new
- (void)twb_sendImageData:(NSData *)imageData {
    [KVNProgress showWithStatus:@"Sending..."];
    [imgrClient uploadImageData:imageData
                   withFilename:@"image.png"
              completionHandler:^(NSURL *imgurURL, NSError *error) {
                    if (error) {
                        [KVNProgress showErrorWithStatus:@"Image Upload Failed"];
                        NSLog(@"*********** Error Upload: %@", [error localizedDescription]);
                    } else {
                        [twitter postDirectMessage:[NSString stringWithFormat:@"%@",imgurURL.absoluteString] forScreenName:mainToUser.screenName orUserID:nil successBlock:^(NSDictionary *message) {
                                         //
                            [KVNProgress showSuccessWithStatus:@"Success"];
                                     } errorBlock:^(NSError *error) {
                                         //
                                        [KVNProgress showErrorWithStatus:@"Send Failed"];
                                     }];
                    }
              }];
}

%new
- (void)twb_sendImage:(UIImage *)imageArg {
    MarkupViewController *mkUI = [[MarkupViewController alloc] init];
    [mkUI setImage:imageArg];
    [mkUI setAllowShakeToUndo:YES];
    [mkUI _createCancelDoneNavBar];
    mkUI.imageBlock = ^(MarkupViewController *mkUI, UIImage *image) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            [KVNProgress showWithStatus:@"Sending..."];
            [imgrClient uploadImage:image
                           withFilename:@"image.png"
                      completionHandler:^(NSURL *imgurURL, NSError *error) {
                            if (error) {
                                [KVNProgress showErrorWithStatus:@"Image Upload Failed"];
                                NSLog(@"*********** Error Upload: %@", [error localizedDescription]);
                            } else {
                                [twitter postDirectMessage:[NSString stringWithFormat:@"%@",imgurURL.absoluteString] forScreenName:mainToUser.screenName orUserID:nil successBlock:^(NSDictionary *message) {
                                                 //
                                        [KVNProgress showSuccessWithStatus:@"Success"];
                                             } errorBlock:^(NSError *error) {
                                                 //
                                                [KVNProgress showErrorWithStatus:@"Send Failed"];
                                             }];
                            }
                      }];
       [mkUI dismissViewControllerAnimated:YES completion:^{}];
    };
    mkUI.cancelBlock = ^(MarkupViewController *mkUI) {
        [mkUI dismissViewControllerAnimated:YES completion:nil];
    };
    mkUI.modalPresentationStyle = UIModalPresentationFormSheet;

    [self presentViewController:mkUI animated:YES completion:^{
        
    }];
}
%new
- (void)sendImageFromSourceType:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    [imgPicker setSourceType:sourceType];
    [imgPicker setDelegate:self];
    [imgPicker setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentViewController:imgPicker animated:YES completion:^{
        
    }];
}
%new
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage* outputImage = [info objectForKey:UIImagePickerControllerEditedImage];
        if (outputImage == nil) {
            outputImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        if (outputImage) {
            [self performSelector:@selector(twb_sendImage:) withObject:outputImage];
        }
    }];
}
%new
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{

    }];
}
%end

// %hook PTHStaticOptionsSectionView
// - (id)initWithOptions:(NSArray *)options colorGroupName:(id)arg2 {
//         for (id object in options) {
//             if ([object isKindOfClass:[NSString class]]) {
//                 NSString *stringFont = (NSString *)object;
//                 if ([stringFont isEqualToString:@"Avenir"]) {
//                     NSArray *newItems = [[NSArray alloc] initWithObjects:@"iMokhles", nil];
//                     options = [options arrayByAddingObjectsFromArray:newItems];
//                 }
//             }
//         }
//     return %orig(options, arg2);
// }
// %end

%hook PTHTweetbotStreamingSettingsController
- (void)loadView {
    // NSString *settingsTitle = [[NSBundle mainBundle] localizedStringForKey:@"Settings" value:@"" table:0x0];
    %orig;
    size_reallocing();
    NSArray *subViewsArray = [self.view subviews];
    UIScrollView *mainScrollView = [subViewsArray objectAtIndex:0];
    PTHStaticSectionView *twbSection =  [mainScrollView.subviews objectAtIndex:0];//[[%c(PTHStaticSectionView)] initWithColorGroupName:@"twbEnhancerSettings"];
    // twbSection.headerTitle = [NSString stringWithFormat:@"TWBEnhancer9 %@", settingsTitle];
    lteCell = [[%c(PTHStaticSectionCell) alloc] initWithType:0x3 colorGroupName:nil];;
    lteCell.text = @"Stream over LTE ";
    [lteCell setOn:[[%c(PTHTweetbotSettings) sharedSettings] isStreamingOverWWANEnabled]];
    [lteCell addTarget:self action:@selector(changeLTE:) forControlEvents:0x1000];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"enableStreamLTE"] == YES) {
        [twbSection addCell:lteCell];
    }
}
%new
- (void)changeLTE:(id)arg1 {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"enableStreamLTE"] == NO) {
        return;
    }
    [[%c(PTHTweetbotSettings) sharedSettings] setStreamingOverWWANEnabled:[arg1 isOn]];
}
%end

%hook PTHTweetbotSettingsController
- (void)loadView {
    // NSString *settingsTitle = [[NSBundle mainBundle] localizedStringForKey:@"Settings" value:@"" table:0x0];
    %orig;
    size_reallocing();
    NSArray *subViewsArray = [self.view subviews];
    UIScrollView *mainScrollView = [subViewsArray objectAtIndex:0];
    PTHStaticSectionView *twbSection =  [mainScrollView.subviews objectAtIndex:0];//[[%c(PTHStaticSectionView)] initWithColorGroupName:@"twbEnhancerSettings"];
    // twbSection.headerTitle = [NSString stringWithFormat:@"TWBEnhancer9 %@", settingsTitle];
    PTHStaticSectionCell *devCell = [[%c(PTHStaticSectionCell) alloc] initWithType:0x1 colorGroupName:nil];;
    devCell.text = @"Developer Settings";
    devCell.detailText = @"Super Secret Settings";
    [devCell addTarget:self action:@selector(_showDeveloperSettings:) forControlEvents:0x40];
    [twbSection addCell:devCell];

    [self performSelector:@selector(addTWBESettingsToSection:) withObject:twbSection];
}

%new
- (void)addTWBESettingsToSection:(PTHStaticSectionView *)section {
    NSArray *cellsArray = @[@"Dm image", @"Stream LTE", @"Disable Favbot", @"Edit Images", @"Share Tweets", @"Delete All Drafts", @"Tweet Over 140chrs", @"Download videos"];
    NSArray *cellsKeysArray = @[@"enableDMCamKey", @"enableStreamLTE", @"enableFavbot", @"enableEditImage", @"enableShareTweet", @"enableDeletaDrafts", @"enableImagePost", @"enableDownloadVideo"];
    for (int i=0; i<[cellsArray count]; i++) {
        PTHStaticSectionCell *camCell = [[%c(PTHStaticSectionCell) alloc] initWithType:0x3 colorGroupName:nil];;
        camCell.text = [NSString stringWithFormat:@"%@", [cellsArray objectAtIndex:i]];
        [camCell setOn:[[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@", [cellsKeysArray objectAtIndex:i]]]];
        [camCell addTarget:self action:@selector(change_twbVlaue:) forControlEvents:0x1000];
        camCell.tag = (i*1000)+1;
        [section addCell:camCell];
    }
}
%new
- (void)change_twbVlaue:(PTHStaticSectionCell *)cell {
    switch(cell.tag/1000) {
        case 0:
             {
                 [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:cell.isOn] forKey:@"enableDMCamKey"];
             }
        break;
        case 1:
             {
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:cell.isOn] forKey:@"enableStreamLTE"];
             }
        break;
        case 2:
             {
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:cell.isOn] forKey:@"enableFavbot"];
             }
        break;
        case 3:
             {
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:cell.isOn] forKey:@"enableEditImage"];
             }
        break;
        case 4:
             {
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:cell.isOn] forKey:@"enableShareTweet"];
             }
        break;
        case 5:
             {
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:cell.isOn] forKey:@"enableDeletaDrafts"];
             }
        break;
        case 6:
             {
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:cell.isOn] forKey:@"enableImagePost"];
             }
        break;
        case 7:
             {
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:cell.isOn] forKey:@"enableDownloadVideo"];
             }
        break;
    }
}

- (void)_showDeveloperSettings:(id)arg1 {
    PTHTweetbotDeveloperSettingsController *devSettings = [[%c(PTHTweetbotDeveloperSettingsController) alloc] init];
    PTHTweetbotShowDelegate *showDelegate = [[%c(PTHTweetbotShowDelegate) alloc] init];
    [showDelegate setPresentOptions:0x20000];
    [showDelegate setShowType:0x2];
    [self showViewController:devSettings delegate:showDelegate];
}
%end

// %hook PTHTweetbotSettings
// - (_Bool)streamingOverWWANEnabled {
//     return TRUE;
// }
// - (_Bool)isStreamingOverWWANEnabled {
//     return TRUE;
// }
// %end

// %hook PTHTweetbotMainController 
// - (BOOL)shouldAutorotate {
//     return NO;
// }
// %end

// %hook PTHTweetbotNavigationController
// - (BOOL)shouldAutorotate {
//     return NO;
// }
// %end

%hook PTHTweetbotStatusDetailActionController
- (void)_showFavorites:(id)arg1 {
    size_reallocing();
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"enableFavbot"] == NO) {
        %orig;
        return;
    }
    PTHTweetbotStatusFavoritesController *favVC = [[%c(PTHTweetbotStatusFavoritesController) alloc] initWithStatus:self.status];
    PTHTweetbotShowDelegate *showDelegate = [%c(PTHTweetbotShowDelegate) delegateForControl:arg1];
    [self showViewController:favVC delegate:showDelegate];
}
%end

%hook PTHTweetbotMediumImageView
- (void)configureActionSheet:(PTHActionSheet *)actionSheet {
    size_reallocing();
    UIImageView *mImageView = MSHookIvar<UIImageView *>(self, "_imageView");
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"enableEditImage"] == NO) {
        %orig;
        return;
    }
    %orig;
    [actionSheet addActionButton:@"Edit Image" selectBlock:^{
        MarkupViewController *mkUI = [[MarkupViewController alloc] init];
        [mkUI setImage:mImageView.image];
        [mkUI setAllowShakeToUndo:YES];
        [mkUI _createCancelDoneNavBar];
        mkUI.imageBlock = ^(MarkupViewController *mkUI, UIImage *image) {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
                UIImageView *mImageView = MSHookIvar<UIImageView *>(self, "_imageView");
                UIImage *mImage = MSHookIvar<UIImage *>(self, "_image");
                NSString *filename = MSHookIvar<NSString *>(self, "_filename");

                mImageView.image = image;
                mImage = image;
                NSData *imageData = UIImagePNGRepresentation(image);
                if (![imageData writeToFile:filename atomically:YES]) {
                    // failure
                    NSLog(@"image save failed to path %@", filename);
                }
           [mkUI dismissViewControllerAnimated:YES completion:^{}];
        };
        mkUI.cancelBlock = ^(MarkupViewController *mkUI) {
            [mkUI dismissViewControllerAnimated:YES completion:nil];
        };
        mkUI.modalPresentationStyle = UIModalPresentationFormSheet;

        [self.controller presentViewController:mkUI animated:YES completion:^{
            
        }];
    }];
}
%end

%hook PTHTweetbotStatusDetailController
- (void)presentActionSheet:(PTHActionSheet *)actionSheet delegate:(id)arg2 completion:(id)arg3 {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"enableShareTweet"] == NO) {
        %orig;
        return;
    }
    [actionSheet addActionButton:[[NSBundle mainBundle] localizedStringForKey:@"Share" value:@"" table:0x0] selectBlock:^{
        PTHTweetbotShowDelegate *showDelegate = [[%c(PTHTweetbotShowDelegate) alloc] init];
        PTHTweetbotStatus *status = self.status;
        [showDelegate setBarButtonItem:[self navigationItem].rightBarButtonItem];
        [showDelegate setPresentOptions:0x1000];
        [showDelegate setSourceObject:status];
        NSString *shareTextString = status.decodedText;
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[shareTextString] applicationActivities:nil];
        [self presentActivityController:activityVC delegate:showDelegate completion:nil];
    }];
    %orig;
}
%end

%hook PTHTweetbotPostDraftsController
- (void)loadView {
    size_reallocing();
    %orig;
    NSMutableArray *postDrafts = MSHookIvar<NSMutableArray *>(self, "_postDrafts");
    if (postDrafts.count > 0) {
        UIBarButtonItem *origEditBtn = [self navigationItem].rightBarButtonItem;
        deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteAllPressed)];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"enableDeletaDrafts"] == YES) {
            [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:origEditBtn, deleteButton, nil]];
        }
    }
}
%new
- (void)deleteAllPressed {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"enableDeletaDrafts"] == NO) {
        return;
    }
    PTHTweetbotAccount *account = MSHookIvar<PTHTweetbotAccount *>(self, "_account");
    NSMutableArray *postDrafts = MSHookIvar<NSMutableArray *>(self, "_postDrafts");

    if (postDrafts.count > 0) {
        PTHActionSheet *actionSheet = [[%c(PTHActionSheet) alloc] init];
        [actionSheet addActionButton:[[NSBundle mainBundle] localizedStringForKey:@"Remove" value:@"" table:0x0] selectBlock:^{
            for (PTHTweetbotPostDraft *draft in [postDrafts copy]) {
                [account deletePostDraft:draft];
                [postDrafts removeAllObjects];
                [self performSelector:@selector(reloadData)];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [actionSheet addActionButton:[[NSBundle mainBundle] localizedStringForKey:@"Cancel" value:@"" table:0x0] selectBlock:^{

        }];
        PTHTweetbotShowDelegate *showDelegate = [[%c(PTHTweetbotShowDelegate) alloc] init];
        [showDelegate setBarButtonItem:deleteButton];
        [showDelegate setPresentOptions:0x1000];
        [self presentActionSheet:actionSheet delegate:showDelegate completion:0x0];
    }
}
%end

%hook PTHTweetbotPostController
- (void)viewDidLoad
{
    size_reallocing();
    %orig;
    [self performSelector:@selector(setupHUDView)];
}

%new
- (void)setupHUDView {
    basicConfiguration = [KVNProgressConfiguration defaultConfiguration];
    basicConfiguration.fullScreen = YES;
}

- (void)viewDidAppear:(BOOL)arg1 {
    [KVNProgress setConfiguration:basicConfiguration];
    %orig;

}
- (void)post:(id)arg1 {
    if (self.draft.text.length > 140 && [[NSUserDefaults standardUserDefaults] boolForKey:@"enableImagePost"] == YES) {
        [KVNProgress showWithStatus:@"Preparing..."];
        SBKTextViewObject *textBobject = [[SBKTextViewObject alloc] init];
        textBobject.text = self.draft.text;
        textBobject.font = [UIFont fontWithName:@"Helvetica" size:17];
        textBobject.textColor = [UIColor blackColor];

        SBKTextView *textView = [[SBKTextView alloc] init];
        [textView addTextObject:textBobject];
   
        UIImage *postImage = [TWBEnhancer9Helper screenshotForView:textView];
        // float width = self.draft.text.length*10;
        // if (width > self.view.frame.size.width) {
        //     width = 310;
        // }
        // NSString *currentString = [self.draft.text substringFromIndex:[self.draft.text length] - 100];
        // NSArray *nArr = [TWBEnhancer9Helper splitString:self.draft.text maxCharacters:39];
        // for (NSMutableString *line in nArr) 
        //     NSLog(@"******** ARRAY : %@", line);

        // float height = [TWBEnhancer9Helper heightForText:self.draft.text withFont:[UIFont fontForFontName:FontNameHelvetica size:17]];
        // UIImage *postImage = [TWBEnhancer9Helper imageFromText:self.draft.text font:FontNameHelvetica fontSize:17 imageSize:CGSizeMake(width, height)];

        UIImageWriteToSavedPhotosAlbum(postImage, nil, nil, nil);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
            fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
            PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
            PHAsset *lastAsset = [fetchResult lastObject];
            PTHTweetbotPostDraftMedium *newImage = [[%c(PTHTweetbotPostDraftMedium) alloc] initWithPHAsset:lastAsset];
            [self.draft addMedium:newImage];
            NSString *substring = [self.draft.text substringToIndex:80];
            self.draft.text = substring;
            [KVNProgress showSuccessWithStatus:@"Success"];
        });
    } else {
        %orig;
    }
}
%end

%hook PTHTweetbotMedium
+ (id)mediumWithEntity:(id)arg1 dictionary:(id)arg2 {
    
    NSLog(@"****** dictionary:(id)arg2 ** %@ \n ", arg2);
    NSMutableDictionary *newDict = [NSMutableDictionary new];
    [newDict addEntriesFromDictionary:arg2[@"video_info"]];
    
    NSMutableDictionary *oldDict = [NSMutableDictionary new];
    [oldDict addEntriesFromDictionary:arg2];
    
    NSMutableArray *newVariants = [NSMutableArray new];
    for (NSDictionary *dict in arg2[@"video_info"][@"variants"]) {
        NSLog(@"****** NSDictionary ** %@ \n ", dict);
        if ([dict[@"content_type"] isEqualToString:@"video/mp4"]) {
            NSLog(@"******** %@ \n ", dict);
            if ([dict[@"bitrate"] integerValue] == 832000 || [dict[@"bitrate"] integerValue] == 320000 || [dict[@"bitrate"] integerValue] == 0) {
                [newVariants addObject:dict];
                [newDict setObject:[newVariants copy] forKey:@"variants"];
            }
        }
        
    }
    [oldDict setObject:[newDict copy] forKey:@"video_info"];
    NSLog(@"******** %@ \n ", [newDict copy]);
    return %orig(arg1, [oldDict copy]);;
}
%end

%hook PTHTweetbotMediumMovieView

- (id)initWithMedium:(PTHTweetbotMedium *)arg1 responseDictionary:(id)arg2 {
    
    id oeifVideo = %orig;
    if (oeifVideo) {
        originalVideoStatusID = [NSString stringWithFormat:@"%lld", arg1.entity.status.originalTID];
    }
    return oeifVideo;
}
- (void)configureActionSheet:(PTHActionSheet *)actionSheet {
    NSLog(@"******* TEEEEST");
    size_reallocing();
    
//    status[@"extended_entities"][@"media"][0][@"video_info"][@"variants"];
    
    AVPlayer *player = MSHookIvar<AVPlayer *>(self, "_player");
    AVPlayerInternal *playerInternal = MSHookIvar<AVPlayerInternal *>(player, "_player");
    AVPlayerItem *playerItem = MSHookIvar<AVPlayerItem *>(playerInternal, "currentItem");;
    AVURLAsset *asset = (AVURLAsset*)[playerItem asset];
    NSURL *url = [asset URL];
    NSString *urlToDownload = [url absoluteString];
    %orig;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"enableDownloadVideo"] == YES) {
        [actionSheet addActionButton:@"Download Video" selectBlock:^{
            if ([urlToDownload containsString:@"mp4"]) {
                [KVNProgress showWithStatus:@"Downloading..."];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSLog(@"Downloading Started");
                    NSURL  *url = [NSURL URLWithString:urlToDownload];
                    NSData *urlData = [NSData dataWithContentsOfURL:url];
                    if ( urlData ) {
                        NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString  *documentsDirectory = [paths objectAtIndex:0];
                        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"thefile.mp4"];
                        //saving is done on main thread
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [urlData writeToFile:filePath atomically:YES];
                            UISaveVideoAtPathToSavedPhotosAlbum(filePath, nil, NULL, NULL);
                            [KVNProgress showSuccessWithStatus:@"Saved"];
                            NSLog(@"File Saved !");
                        });
                    }
                    
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [KVNProgress showErrorWithStatus:@"Failed"];
                });
            }
//            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"enableDownloadVideo"] == YES) {
//                PTHAlertController *downAlert = [[%c(PTHAlertController) alloc] init];
//                [downAlert setTitle:@"TWBEnhancer9 Lite"];
//                [downAlert setMessage:@"This is a lite version, if u need this feature u have to get the paid version from Cydia, Thanks"];
//                [downAlert setCancelButtonTitle:[[NSBundle mainBundle] localizedStringForKey:@"Ok" value:@"" table:0x0]];
//                [downAlert setDidCancelBlock:^{
//                    
//                }];
//                [self.controller presentViewController:downAlert animated:YES completion:nil];
//            }
            
        }];
    }
    
}
%end

%hook PTHTweetbotMediaController
- (void)viewWillAppear:(BOOL)arg1 {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFile_twb:) name:@"AVPlayerItemBecameCurrentNotification" object:nil];
    %orig;
}
- (void)viewDidLoad
{
    %orig;
    [self performSelector:@selector(setupHUDView)];
}

%new
- (void)setupHUDView {
    basicConfiguration = [KVNProgressConfiguration defaultConfiguration];
    basicConfiguration.fullScreen = YES;
}

- (void)viewDidAppear:(BOOL)arg1 {
    [KVNProgress setConfiguration:basicConfiguration];
    %orig;

}
%new
- (void)downloadFile_twb:(NSNotification *)notification {
    if ([notification.name isEqualToString:@"AVPlayerItemBecameCurrentNotification"]) {
       // AVPlayerItem *playerItem  = [notification object];
       //  if (playerItem == nil) {
       //      return;
       //  }
       //  AVURLAsset *asset = (AVURLAsset*)[playerItem asset];
       //  NSURL *url = [asset URL];
       //  NSString *urlToDownload = [url absoluteString];
        
       //  PTHAlertController *downAlert = [[%c(PTHAlertController) alloc] init];
       //  [downAlert setTitle:@"Download Media"];
       //  [downAlert setMessage:@"Do you want download this media ?"];
       //  [downAlert setCancelButtonTitle:[[NSBundle mainBundle] localizedStringForKey:@"Cancel" value:@"" table:0x0]];
       //  [downAlert setOKButtonTitle:[[NSBundle mainBundle] localizedStringForKey:@"OK" value:@"" table:0x0]];
       //  [downAlert setDidCancelBlock:^{

       //  }];
       //  [downAlert setDidOKBlock:^{
       //      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       //          NSLog(@"Downloading Started");
       //          NSURL  *url = [NSURL URLWithString:urlToDownload];
       //          NSData *urlData = [NSData dataWithContentsOfURL:url];
       //          if ( urlData ) {
       //              NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
       //              NSString  *documentsDirectory = [paths objectAtIndex:0];
       //              NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"thefile.mp4"];
       //              //saving is done on main thread
       //              dispatch_async(dispatch_get_main_queue(), ^{
       //                  [urlData writeToFile:filePath atomically:YES];
       //                  NSLog(@"File Saved !");
       //              });
       //          }

       //      });
       //  }];
       //  [self presentViewController:downAlert animated:YES completion:nil];
   }
}
%end

%hook _PTHSteppedSlider
- (void)setMinimumValue:(float)arg1 {
    %orig(5.0f);
}
- (void)setMaximumValue:(float)arg1 {
    %orig(100.0f);
}
%end

// Markup block :)
static const void *MarkupCancelBlockKey                        = &MarkupCancelBlockKey;
static const void *MarkupImageBlockKey                           = &MarkupImageBlockKey;

%hook MarkupViewController
- (void)done:(id)arg1 {
    UIImage *imageNW = [TWBEnhancer9Helper screenshotForView:self.contentViewController.imageView];
    self.imageBlock(self, imageNW);
}
- (void)cancel:(id)arg1 {
    self.cancelBlock(self);
}

%new
- (MarkupFinishedWithImage)imageBlock {
    return objc_getAssociatedObject(self, MarkupImageBlockKey);
}
%new
- (void)setImageBlock:(MarkupFinishedWithImage)imageBlock {
    objc_setAssociatedObject(self, MarkupImageBlockKey, imageBlock, OBJC_ASSOCIATION_COPY);
}
%new
- (MarkupCancelBlock)cancelBlock {
    return objc_getAssociatedObject(self, MarkupCancelBlockKey);
}
%new
- (void)setCancelBlock:(MarkupCancelBlock)cancelBlock {
    objc_setAssociatedObject(self, MarkupCancelBlockKey, cancelBlock, OBJC_ASSOCIATION_COPY);
}

%end
%end

%group SBTwitterAlert
%hook SBLockScreenManager

- (void)_finishUIUnlockFromSource:(int)source withOptions:(id)options
{
    %orig;
    NSNumber *showWelcomeNU = (NSNumber *)CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("twbenhancer9Welcome"), (CFStringRef)TWEAK_SETTINGS));
    if ([showWelcomeNU boolValue] == NO)
    {
        [[iMoDevTools sharedInstance] isThisThingIsCorrect:@"com.imokhles.twbenhancer9" withBlock:^(BOOL isOK) {
            if (!isOK) {
                [[iMoDevTools sharedInstance] showTwitterFollowAlertWithTweakName:@"TWBEnhancer9" message:@"Seems that you didn't buy me/ or you downloaded me from outside BigBoss or iMokhles's repo \n, if you need to test me, \njust check TWBEnhancer9 Lite from Cydia,\n\nor you have Dpkg Check package (tweak) installed and this is an illigal package, so you have to uninstall this package to make me work,\n\n  also if u want to follow my developer \nto get updates and cool stuffs, click on (I'd love to!)" accountName:@"iMokhles"];
            } else {
                [[iMoDevTools sharedInstance] showTwitterFollowAlertWithTweakName:@"TWBEnhancer9" message:@"if u want to follow my developer \nto get updates and cool stuffs, click on (I'd love to!)" accountName:@"iMokhles"];
                CFPreferencesSetAppValue(CFSTR("twbenhancer9Welcome"), kCFBooleanTrue, (CFStringRef)TWEAK_SETTINGS);
                CFPreferencesAppSynchronize((CFStringRef)TWEAK_SETTINGS);
            }
        }];
    }
}

%end
%end

//int (*original__BSAuditTokenTaskHasEntitlement)(int unknownFlag, NSString *entitlement);
//int replaced__BSAuditTokenTaskHasEntitlement(int unknownFlag, NSString *entitlement)
//{
//    if ([entitlement isEqualToString:@"com.apple.private.MobileGestalt.AllowedProtectedKeys"]) {
//        return @"UniqueDeviceID";
//    }
//    
//    return original__BSAuditTokenTaskHasEntitlement(unknownFlag, entitlement);
//}
%ctor {
	@autoreleasepool {
		[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *block) {
	        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)TWBEnhancer9_Prefs, [TWBEnhancer9Helper preferencesChanged], NULL, 0);
	        TWBEnhancer9_Prefs();
	 
	    }];
        if ([[[NSProcessInfo processInfo] processName] isEqualToString:@"SpringBoard"]) {
            %init(SBTwitterAlert);
        } else if ([[[NSProcessInfo processInfo] processName] isEqualToString:@"Tweetbot"]) {
            %init(main);
        }
	}
}
