//
//  TWBEnhancer9ListController.h
//  TWBEnhancer9
//
//  Created by iMokhles on 23.10.2015.
//  Copyright (c) 2015 iMokhles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <substrate.h>
#import "STTwitter/STTwitter.h"

@interface UIViewController (PTHTweetbotPresentationDelegateCategory)
- (void)presentActivityController:(id)arg1 delegate:(id)arg2 completion:(id)arg3;
- (void)presentActionSheet:(id)arg1 delegate:(id)arg2 completion:(id)arg3;
- (void)showViewController:(id)arg1 delegate:(id)arg2;
- (void)showViewController:(id)arg1 delegate:(id)arg2 completion:(id)arg3;
- (void)_pushViewController:(id)arg1 delegate:(id)arg2 completion:(id)arg3;
- (void)_presentViewController:(id)arg1 delegate:(id)arg2 completion:(id)arg3;
@end

@interface NSData ()
- (_Bool)isPNGData;
@end

@interface PTHTweetbotAppDelegate : NSObject <STTwitterAPIOSProtocol>
@end

@class PTHTweetbotCurrentUser;
@interface PTHTweetbotAccount : NSObject
+ (id)accounts;
@property(copy, nonatomic) NSString *username;
- (void)deletePostDraft:(id)arg1;
@property(retain, nonatomic) PTHTweetbotCurrentUser *currentUser;
@end

@interface PTHTweetbotService : NSObject {
	 PTHTweetbotAccount *_account;
}
+ (_Bool)isAvailable;
+ (_Bool)verifyWithAccount:(id)arg1;
+ (_Bool)needsAuthentication;
@end

@interface PTHTweetbotMediaService : PTHTweetbotService
@end

@interface PTHURLRequest : NSObject
@property(readonly, nonatomic) NSURL *urlWithParams;
@property(readonly, nonatomic) NSString *requestMethodString;
@property(readonly, nonatomic) NSMutableDictionary *debugDictionary;
@property(readonly, nonatomic) NSHTTPURLResponse *response;
@property(copy, nonatomic) NSDictionary *postDictionary; // @synthesize postDictionary=_postDictionary;
@property(nonatomic) unsigned long long responseQueue; // @synthesize responseQueue=_responseQueue;
@property(nonatomic) unsigned long long responseType; // @synthesize responseType=_responseType;
@property(copy, nonatomic) NSDictionary *headerDictionary; // @synthesize headerDictionary=_headerDictionary;
@property(copy, nonatomic) NSDictionary *queryDictionary; // @synthesize queryDictionary=_queryDictionary;
@property(nonatomic) unsigned long long postContentType; // @synthesize postContentType=_postContentType;
@property(copy, nonatomic) NSData *postData; // @synthesize postData=_postData;
@property(nonatomic) _Bool continueInBackground; // @synthesize continueInBackground=_continueInBackground;
@property(nonatomic, getter=isNetworkActivityEnabled) _Bool networkActivityEnabled; // @synthesize networkActivityEnabled=_networkActivityEnabled;
@property(retain, nonatomic) NSURLRequest *urlRequest; // @synthesize urlRequest=_urlRequest;
@property(copy, nonatomic) NSString *password; // @synthesize password=_password;
@property(copy, nonatomic) NSString *username; // @synthesize username=_username;
@property(copy, nonatomic) NSString *filename; // @synthesize filename=_filename;
@property(retain, nonatomic) NSURLCredential *credential; // @synthesize credential=_credential;
@property(nonatomic) _Bool cookiesEnabled; // @synthesize cookiesEnabled=_cookiesEnabled;
@end

@interface PTHOAuthURLRequest : PTHURLRequest
@property(nonatomic) double serverTimeOffset; // @synthesize serverTimeOffset=_serverTimeOffset;
@property(copy, nonatomic) NSString *realm; // @synthesize realm=_realm;
@property(copy, nonatomic) NSString *verifier; // @synthesize verifier=_verifier;
@property(copy, nonatomic) NSString *tokenSecret; // @synthesize tokenSecret=_tokenSecret;
@property(copy, nonatomic) NSString *token; // @synthesize token=_token;
@property(copy, nonatomic) NSString *consumerSecret; // @synthesize consumerSecret=_consumerSecret;
@property(copy, nonatomic) NSString *consumerKey; // @synthesize consumerKey=_consumerKey;
- (id)headerDictionary;
@end

@interface PTHTweetbotOAuthURLRequest : PTHOAuthURLRequest
{
    _Bool _concurrent;
}

+ (void)updateServerTimeOffset:(id)arg1;
+ (void)updateServerTimeOffsetFromHeaders:(id)arg1;
+ (id)serverDateFormatter;
@property(nonatomic, getter=isConcurrent) _Bool concurrent; // @synthesize concurrent=_concurrent;
- (double)serverTimeOffset;

@end

@interface PTHTweetbotTwitterMediaService : NSObject {
	PTHTweetbotOAuthURLRequest *_urlRequest;
}
- (void)_uploadImage:(id)arg1 medium:(id)arg2 progress:(id)arg3 completion:(id)arg4;
- (void)uploadMedium:(id)arg1 withMessage:(id)arg2 progress:(id)arg3 completion:(id)arg4;
@end

@interface PTHViewController : UIViewController
@end

@class PTHTweetbotUser;
@interface PTHTweetbotDirectMessageThread : NSObject
{
    long long _lastReadTID;
    unsigned long long _unreadItemCount;
}

@property(readonly, nonatomic) unsigned long long unreadItemCount; // @synthesize unreadItemCount=_unreadItemCount;
@property(nonatomic) long long lastReadTID; // @synthesize lastReadTID=_lastReadTID;
@property(readonly, nonatomic, getter=isRead) _Bool read;
@property(readonly, copy, nonatomic) NSArray *messages;
@property(readonly, nonatomic) long long otherUserTID;
@property(readonly, nonatomic) PTHTweetbotUser *otherUser; // @synthesize otherUser=_otherUser;

@end

@interface PTHTweetbotObject : NSObject
@end

@interface PTHTweetbotUser : PTHTweetbotObject
+ (id)profileImageURLFromString:(id)arg1 forSize:(unsigned long long)arg2;
+ (_Bool)isTapbotTID:(long long)arg1;
+ (_Bool)isValidScreenName:(id)arg1;
+ (id)newWithAccount:(id)arg1 dictionary:(id)arg2;
+ (id)newWithAccount:(id)arg1 tid:(long long)arg2;
- (unsigned long long)hash;
- (_Bool)isEqual:(id)arg1;
- (long long)compare:(id)arg1;
- (_Bool)hasString:(id)arg1;
@property(readonly, nonatomic) __weak NSURL *twitterURL;
@property(readonly, nonatomic) __weak NSURL *favstarURL;
@property(readonly, nonatomic) _Bool isTapbot;
- (id)profileBannerURLForWidth:(unsigned long long)arg1;
- (id)profileImageURLForSize:(unsigned long long)arg1;
@property(copy, nonatomic) NSString *urlString; // @synthesize urlString=_urlString;
@property(copy, nonatomic) NSString *profileBannerImageURLString; // @synthesize profileBannerImageURLString=_profileBannerImageURLString;
@property(copy, nonatomic) NSString *profileImageURLString; // @synthesize profileImageURLString=_profileImageURLString;
@property(copy, nonatomic) NSString *userDescription; // @synthesize userDescription=_userDescription;
@property(copy, nonatomic) NSString *location; // @synthesize location=_location;
@property(copy, nonatomic) NSString *screenName; // @synthesize screenName=_screenName;
@property(copy, nonatomic) NSString *name; // @synthesize name=_name;
@property(retain, nonatomic) NSDate *updatedAt; // @synthesize updatedAt=_updatedAt;
@property(retain, nonatomic) NSDate *createdAt; // @synthesize createdAt=_createdAt;
@property(nonatomic) long long listedCount; // @synthesize listedCount=_listedCount;
@property(nonatomic) long long statusesCount; // @synthesize statusesCount=_statusesCount;
@property(nonatomic) long long followingCount; // @synthesize followingCount=_followingCount;
@property(nonatomic) long long followersCount; // @synthesize followersCount=_followersCount;
@property(nonatomic) long long favoritesCount; // @synthesize favoritesCount=_favoritesCount;
@property(nonatomic, getter=isRefreshing) _Bool refreshing; // @synthesize refreshing=_refreshing;
@property(readonly, nonatomic, getter=isMissing) _Bool missing; // @synthesize missing=_missing;
@property(nonatomic, getter=isVerified) _Bool verified; // @synthesize verified=_verified;
// @property(nonatomic, getter=isProtected) _Bool protected; // @synthesize protected=_protected;
@property(retain, nonatomic) NSDate *lastStatusCreatedAt; // @synthesize lastStatusCreatedAt=_lastStatusCreatedAt;
@property(readonly, nonatomic) _Bool isCurrentUser;
- (id)attributedUserDescription:(_Bool)arg1;
- (void)updateFromDictionary:(id)arg1;
@end

@interface PTHTweetbotCurrentUser : PTHTweetbotUser

@end

@interface PTHTweetbotPostDraft : NSObject
@property(copy, nonatomic) NSString *text; // @synthesize text=_text;
@property(retain, nonatomic) PTHTweetbotUser *toUser;
@property(nonatomic) __weak PTHTweetbotAccount *account; // @synthesize account=_account;
- (void)_uploadMedia:(double)arg1 progress:(id)arg2 completion:(id)arg3;
- (id)initWithQuoteStatus:(id)arg1;
- (id)initWithReplyStatus:(id)arg1;
- (id)initWithToUser:(id)arg1;
- (id)initWithAccount:(id)arg1;
- (id)init;
- (_Bool)canAddMediumType:(long long)arg1;
- (void)deleteMedium:(id)arg1;
- (void)removeMedium:(id)arg1;
- (void)addMedium:(id)arg1;
@end

@interface PTHTweetbotDirectMessagesController : PTHViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, STTwitterAPIOSProtocol, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate> {
    PTHTweetbotDirectMessageThread *_directMessageThread;
}
- (void)viewDidDisappear:(_Bool)arg1;
- (void)viewWillDisappear:(_Bool)arg1;
- (void)viewDidAppear:(_Bool)arg1;
- (void)viewWillAppear:(_Bool)arg1;

// new
- (void)chooseAccount;
- (void)loginWithiOSAccount:(ACAccount *)account;
- (void)sendImageFromSourceType:(UIImagePickerControllerSourceType)sourceType;
@end

@class PTHTweetbotStatus;
@interface PTHTweetbotEntity : NSObject
@property(nonatomic) __weak PTHTweetbotStatus *status;
@end

@interface PTHTweetbotMedium : NSObject
@property(readonly, nonatomic) _Bool isiTunes;
@property(readonly, nonatomic) _Bool isImage;
@property(readonly, nonatomic) _Bool shouldMovieLoop;
@property(readonly, nonatomic) _Bool isMovie;
@property(retain, nonatomic) NSDictionary *previewURLDictionary; // @synthesize previewURLDictionary=_previewURLDictionary;
@property(retain, nonatomic) NSURL *url; // @synthesize url=_url;
@property(nonatomic, getter=isiOSApp) _Bool iOSApp; // @synthesize iOSApp=_iOSApp;
@property(nonatomic, getter=isMacApp) _Bool macApp; // @synthesize macApp=_macApp;
@property(nonatomic) __weak PTHTweetbotEntity *entity;
@end

@interface PTHTweetbotPostDraftMedium : PTHTweetbotMedium
- (id)initWithPHAsset:(id)arg1;
- (id)initWithImagePickerDictionary:(id)arg1;
@end

@interface PTHTweetbotMediumMovieView : UIView <STTwitterAPIOSProtocol> {
    AVPlayer *_player;
}
@end

@interface PTHActionSheet : PTHViewController
- (id)addDeleteButton:(id)arg1 selectBlock:(id)arg2;
- (id)addActionButton:(id)arg1 selectBlock:(id)arg2;
- (id)addActionButton:(id)arg1 withCode:(long long)arg2 andButtonType:(long long)arg3;
@end

@interface PTHTweetbotShowDelegate : NSObject
@property(nonatomic) unsigned long long permittedArrowDirections; // @synthesize permittedArrowDirections=_permittedArrowDirections;
@property(retain, nonatomic) id sourceObject; // @synthesize sourceObject=_sourceObject;
@property(retain, nonatomic) UIBarButtonItem *barButtonItem; // @synthesize barButtonItem=_barButtonItem;
@property(nonatomic) struct CGRect sourceRect; // @synthesize sourceRect=_sourceRect;
@property(retain, nonatomic) UIView *sourceView; // @synthesize sourceView=_sourceView;
@property(nonatomic) unsigned long long presentOptions; // @synthesize presentOptions=_presentOptions;
@property(nonatomic) long long showType; // @synthesize showType=_showType;
+ (id)delegateForDelegate:(id)arg1;
+ (id)delegateForControl:(id)arg1;
- (void)popoverPresentationController:(id)arg1 willRepositionPopoverToRect:(CGRect )arg2 inView:(UIView *)arg3;
- (long long)adaptivePresentationStyleForPresentationController:(id)arg1 traitCollection:(id)arg2;
- (long long)modalPresentationStyle;
@end

@interface PTHTweetbotStatus : PTHTweetbotObject
@property(readonly, nonatomic) _Bool isFromCurrentUser;
@property(readonly, nonatomic) _Bool isReplyToCurrentUser;
@property(readonly, nonatomic) _Bool isReply;
@property(readonly, nonatomic) _Bool canRetweet;
@property(readonly, nonatomic) _Bool canUnretweet;
@property(readonly, nonatomic) _Bool isRetweet;
@property(readonly, nonatomic) __weak NSString *emailHTML;
@property(readonly, nonatomic) __weak NSURL *favstarURL;
@property(readonly, nonatomic) __weak NSURL *twitterURL;
@property(readonly, nonatomic) NSURL *sourceURL; // @synthesize sourceURL=_sourceURL;
@property(readonly, copy, nonatomic) NSString *sourceText; // @synthesize sourceText=_sourceText;
@property(readonly, nonatomic) NSString *expandedURLText; // @synthesize expandedURLText=_expandedURLText;
@property(readonly, nonatomic) __weak NSString *decodedText;
@property(readonly, nonatomic) NSAttributedString *attributedText; // @synthesize attributedText=_attributedText;
@property(readonly, copy, nonatomic) NSString *source; // @synthesize source=_source;
@property(nonatomic) unsigned long long quoteCount; // @synthesize quoteCount=_quoteCount;
@property(nonatomic) unsigned long long replyCount; // @synthesize replyCount=_replyCount;
@property(nonatomic) unsigned long long retweetCount; // @synthesize retweetCount=_retweetCount;
@property(nonatomic, getter=isRetweeted) _Bool retweeted; // @synthesize retweeted=_retweeted;
@property(nonatomic) unsigned long long favoriteCount; // @synthesize favoriteCount=_favoriteCount;
@property(nonatomic, getter=isFavorited) _Bool favorited; // @synthesize favorited=_favorited;
@property(readonly, nonatomic) _Bool quotesCurrentUser; // @synthesize quotesCurrentUser=_quotesCurrentUser;
@property(readonly, nonatomic) _Bool mentionsCurrentUser; // @synthesize mentionsCurrentUser=_mentionsCurrentUser;
@property(readonly, nonatomic) long long replyUserTID; // @synthesize replyUserTID=_replyUserTID;
@property(readonly, nonatomic) long long replyStatusTID; // @synthesize replyStatusTID=_replyStatusTID;
@property(readonly, nonatomic) long long retweetedStatusTID; // @synthesize retweetedStatusTID=_retweetedStatusTID;
@property(readonly, nonatomic) long long originalTID;
@property(readonly, copy, nonatomic) NSString *text; // @synthesize text=_text;
@property(readonly, nonatomic) NSDate *createdAt; // @synthesize createdAt=_createdAt;
@end

