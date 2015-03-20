//
//  UMComMutiStyleTextView.h
//  UMCommunity
//
//  Created by umeng on 15-3-5.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UMComLike.h"
//#import "UMComUser.h"
#import "UMComMutiTextRun.h"

typedef NS_OPTIONS(NSUInteger, UMComMutiTextRunTypeList)
{
    UMComMutiTextRunNoneType  = 0,
    UMComMutiTextRunLikeType = 1,
    UMComMutiTextRunCommentType = 2,
    UMComMutiTextRunFeedContentType = 3,
    UMComMutiTextRunURLType = 4,
    UMComMutiTextRunEmojiType = 5,
    UMComMutiTextRunCommonType = 6,
    UMComMutiTextRunAllType = 7
};


@class UMComMutiTextRunDelegate;
@class UMComMutiTextRun;
@class UMComMutiStyleTextView;

@protocol UMComMutiStyleTextViewDelegate<NSObject>

@optional
- (void)mutiTextView:(UMComMutiStyleTextView *)view touchBeginRun:(UMComMutiTextRun *)run;
- (void)mutiTextView:(UMComMutiStyleTextView *)view touchEndRun:(UMComMutiTextRun *)run;
- (void)mutiTextView:(UMComMutiStyleTextView *)view touchCanceledRun:(UMComMutiTextRun *)run;

@end


@interface UMComMutiStyleTextView : UITextView

@property (nonatomic, strong) NSMutableArray *clikTextDict;

@property (nonatomic, copy) void (^clickOnlinkText)(UMComMutiTextRun *run);

@property (nonatomic, strong) UIImageView *backGroundImageView;

@property (nonatomic,weak) id<UMComMutiStyleTextViewDelegate> delegage;

@property (nonatomic,copy)   NSString              *originString;

//@property (nonatomic,strong) UIFont  *font;
//
//@property (nonatomic,strong) UIColor *textColor;

@property (nonatomic,copy)   NSMutableAttributedString *attributedString;

@property (nonatomic,assign) UMComMutiTextRunTypeList runType;

@property (nonatomic,assign) CGFloat               lineSpace;

@property (nonatomic,assign) CGFloat               heightOffset;

@property (nonatomic,assign) CGPoint               pointOffset;


@property (nonatomic, strong) CALayer *textLayer;


+ (NSMutableAttributedString *)createAttributedStringWithText:(NSString *)text font:(UIFont *)font lineSpace:(CGFloat)lineSpace;

+ (NSArray *)createTextRunsWithAttString:(NSMutableAttributedString *)attString runTypeList:(UMComMutiTextRunTypeList)typeList;

+ (NSArray *)createTextRunsWithAttString:(NSMutableAttributedString *)attString runType:(UMComMutiTextRunTypeList)type clickDicts:(NSMutableArray *)dicts;

+ (CGRect)boundingRectWithSize:(CGSize)size font:(UIFont *)font AttString:(NSMutableAttributedString *)attString;

+ (CGRect)boundingRectWithSize:(CGSize)size font:(UIFont *)font string:(NSString *)string lineSpace:(CGFloat )lineSpace;

@end



