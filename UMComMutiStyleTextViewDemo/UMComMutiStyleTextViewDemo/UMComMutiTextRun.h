//
//  UMMutiTextRun.h
//  UMComMutiStyleTextViewDemo
//
//  Created by umeng on 15-3-12.
//  Copyright (c) 2015年 umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

//***********************文字单元CTRun*************************************

extern NSString * const UMComMutiTextRunAttributedName;

@interface UMComMutiTextRun : UIResponder
/**
 *  文本单元内容
 */
@property (nonatomic,copy  ) NSString *text;

/**
 *  文本单元字体
 */
@property (nonatomic,strong) UIFont   *font;

/**
 *  文本单元颜色
 */
@property (nonatomic,strong) UIColor   *textColor;


/**
 * 被选中的颜色
 */
@property (nonatomic,strong) UIColor   *selectedColor;


/**
 *  文本单元在字符串中的位置
 */
@property (nonatomic,assign) NSRange  range;


/**
 *  是否自己绘制自己
 */
@property(nonatomic,getter = isDrawSelf) BOOL drawSelf;

/**
 *  向字符串中添加相关Run类型属性
 */
- (void)decorateToAttributedString:(NSMutableAttributedString *)attributedString range:(NSRange)range;

/**
 *  绘制Run内容
 */
- (void)drawRunWithRect:(CGRect)rect;

@end




//************************UMComMutiTextRunDelegate******************************************


@interface UMComMutiTextRunDelegate : UMComMutiTextRun

@end





//********************普通TextCTRun*************************************

@interface UMComMutiTextRunCommomText : UMComMutiTextRun
+ (NSArray *)runsForAttributedString:(NSMutableAttributedString *)attributedString;

@end




//********************点击用户名CTRun*************************************
@interface UMComMutiTextRunClickUser : UMComMutiTextRun

//@property (nonatomic, strong) UMComUser *user;

+ (NSArray *)runsForAttributedString:(NSMutableAttributedString *)attributedString withClickDicts:(NSArray *)dicts;

@end




//**********************************点击喜欢的人的姓名*************************************

@interface UMComMutiTextRunLike : UMComMutiTextRun

//@property (nonatomic, strong) UMComLike *like;

+ (NSArray *)runsForAttributedString:(NSMutableAttributedString *)attributedString withClickDicts:(NSArray *)dicts;

@end


//******************评论*************************************

@interface UMComMutiTextRunComment : UMComMutiTextRun

//@property (nonatomic, strong) UMComComment *comment;

+ (NSArray *)runsForAttributedString:(NSMutableAttributedString *)attributedString withClickDicts:(NSArray *)dicts;

@end


//******************话题*************************************

@interface UMComMutiTextRunTopic : UMComMutiTextRun

//@property (nonatomic, strong) UMComTopic *topic;

+ (NSArray *)runsForAttributedString:(NSMutableAttributedString *)attributedString;
@end



//**********************************暂时没有用到*************************************************
@interface UMComMutiTextRunURL : UMComMutiTextRun

/**
 *  解析字符串中url内容生成Run对象
 *
 *  @param attributedString 内容
 *
 *  @return UMComMutiTextRunURL对象数组
 */
+ (NSArray *)runsForAttributedString:(NSMutableAttributedString *)attributedString;

@end


@interface UMComMutiTextRunEmoji : UMComMutiTextRunDelegate

/**
 *  解析字符串中url内容生成Run对象
 *
 *  @param attributedString 内容
 *
 *  @return UMComMutiTextRunURL对象数组
 */
+ (NSArray *)runsForAttributedString:(NSMutableAttributedString *)attributedString;

@end


