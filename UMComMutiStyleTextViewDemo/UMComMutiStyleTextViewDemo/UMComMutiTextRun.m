//
//  UMMutiTextRun.m
//  UMComMutiStyleTextViewDemo
//
//  Created by umeng on 15-3-12.
//  Copyright (c) 2015年 umeng. All rights reserved.
//

#import "UMComMutiTextRun.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>


NSString * const UMComMutiTextRunAttributedName = @"UMComMutiTextRunAttributedName";

@implementation UMComMutiTextRun

/**
 *  向字符串中添加相关Run类型属性
 */
- (void)decorateToAttributedString:(NSMutableAttributedString *)attributedString range:(NSRange)range
{
    if (attributedString.length == 0) {
        return;
    }
    [attributedString addAttribute:UMComMutiTextRunAttributedName value:self range:range];
    
    self.font = [attributedString attribute:NSFontAttributeName atIndex:0 longestEffectiveRange:nil inRange:range];
}

/**
 *  绘制Run内容
 */
- (void)drawRunWithRect:(CGRect)rect
{
    
}

@end


@implementation UMComMutiTextRunDelegate

/**
 *  向字符串中添加相关Run类型属性
 */
- (void)decorateToAttributedString:(NSMutableAttributedString *)attributedString range:(NSRange)range
{
    [super decorateToAttributedString:attributedString range:range];
    
    CTRunDelegateCallbacks callbacks;
    callbacks.version    = kCTRunDelegateVersion1;
    callbacks.dealloc    = UMComMutiTextRunDelegateDeallocCallback;
    callbacks.getAscent  = UMComMutiTextRunDelegateGetAscentCallback;
    callbacks.getDescent = UMComMutiTextRunDelegateGetDescentCallback;
    callbacks.getWidth   = UMComMutiTextRunDelegateGetWidthCallback;
    
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&callbacks, (__bridge void*)self);
    [attributedString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:range];
    CFRelease(runDelegate);
    
    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor clearColor].CGColor range:range];
}

#pragma mark - RunCallback

- (void)mutiTextRunDealloc
{
    
}

- (CGFloat)mutiTextRunGetAscent
{
    return self.font.ascender;
}

- (CGFloat)mutiTextRunGetDescent
{
    return self.font.descender;
}

- (CGFloat)mutiTextRunGetWidth
{
    return self.font.ascender - self.font.descender;
}

#pragma mark - RunDelegateCallback

void UMComMutiTextRunDelegateDeallocCallback(void *refCon)
{
    //    UMComMutiTextRunDelegate *run =(__bridge UMComMutiTextRunDelegate *) refCon;
    //
    //    [run mutiTextRunDealloc];
}

//--上行高度
CGFloat UMComMutiTextRunDelegateGetAscentCallback(void *refCon)
{
    UMComMutiTextRunDelegate *run =(__bridge UMComMutiTextRunDelegate *) refCon;
    
    return [run mutiTextRunGetAscent];
}

//--下行高度
CGFloat UMComMutiTextRunDelegateGetDescentCallback(void *refCon)
{
    UMComMutiTextRunDelegate *run =(__bridge UMComMutiTextRunDelegate *) refCon;
    
    return [run mutiTextRunGetDescent];
}

//-- 宽
CGFloat UMComMutiTextRunDelegateGetWidthCallback(void *refCon)
{
    UMComMutiTextRunDelegate *run =(__bridge UMComMutiTextRunDelegate *) refCon;
    
    return [run mutiTextRunGetWidth];
}

@end



@implementation UMComMutiTextRunCommomText

- (void)decorateToAttributedString:(NSMutableAttributedString *)attributedString range:(NSRange)range
{
    if (attributedString.length == 0) {
        return;
    }
    [super decorateToAttributedString:attributedString range:range];
    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:self.textColor range:range];
}

+ (NSArray *)runsForAttributedString:(NSMutableAttributedString *)attributedString withClickDicts:(NSArray *)dicts
{
    NSMutableArray *runsArr = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *dict in dicts) {
        NSString *key = [dict allKeys].firstObject;
        id obj = [dict valueForKey:key];
        UMComMutiTextRunCommomText *run = [[UMComMutiTextRunCommomText alloc]init];
        run.text = @"这是个普通的Text";
        run.textColor = [UIColor redColor];
        run.range = NSRangeFromString(key);
        run.font = [UIFont systemFontOfSize:20];
        [run decorateToAttributedString:attributedString range:run.range];
        [runsArr addObject:run];
    }
    return runsArr;
}



@end




@implementation UMComMutiTextRunClickUser

- (void)decorateToAttributedString:(NSMutableAttributedString *)attributedString range:(NSRange)range
{
    if (attributedString.length == 0) {
        return;
    }
    [super decorateToAttributedString:attributedString range:range];
    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:self.textColor range:range];
}

+ (NSArray *)runsForAttributedString:(NSMutableAttributedString *)attributedString withClickDicts:(NSArray *)dicts
{
    NSMutableArray *runsArr = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *dict in dicts) {
        NSString *key = [dict allKeys].firstObject;
        id obj = [dict valueForKey:key];
        UMComMutiTextRunClickUser *run = [[UMComMutiTextRunClickUser alloc]init];
        run.text = @"这是一个中国人";
        run.textColor = [UIColor redColor];
        run.range = NSRangeFromString(key);
        run.font = [UIFont systemFontOfSize:20];
        [run decorateToAttributedString:attributedString range:run.range];
        [runsArr addObject:run];
    }
    return runsArr;
}



@end



@implementation UMComMutiTextRunLike

- (void)decorateToAttributedString:(NSMutableAttributedString *)attributedString range:(NSRange)range
{
    if (attributedString.length == 0) {
        return;
    }
    [super decorateToAttributedString:attributedString range:range];
    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)self.textColor.CGColor range:range];
}

+ (NSArray *)runsForAttributedString:(NSMutableAttributedString *)attributedString withClickDicts:(NSArray *)dicts
{
    NSMutableArray *runsArr = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *dict in dicts) {
        NSString *key = [dict allKeys].firstObject;
        UMComMutiTextRunClickUser *run = [[UMComMutiTextRunClickUser alloc]init];
        id obj = [dict valueForKey:key];
        run.textColor = [UIColor blueColor];
        run.font = [UIFont systemFontOfSize:23];//UMComFontNotoSansLightWithSafeSize(14);
        run.range = NSRangeFromString(key);
        [run decorateToAttributedString:attributedString range:run.range];
        [runsArr addObject:run];
    }
    
    return runsArr;
}

@end



@implementation UMComMutiTextRunComment

- (void)decorateToAttributedString:(NSMutableAttributedString *)attributedString range:(NSRange)range
{
    if (attributedString.length == 0) {
        return;
    }
    [super decorateToAttributedString:attributedString range:range];
    //    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)self.textColor.CGColor range:range];
}

+ (NSArray *)runsForAttributedString:(NSMutableAttributedString *)attributedString withClickDicts:(NSArray *)dicts
{
    //    ((\d{11})|^((\d{7,8})|(\d{4}|\d{3})-(\d{7,8})|(\d{4}|\d{3})-(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1})|(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1}))$)
    NSMutableArray *runsArr = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *dict in dicts) {
        NSString *key = [dict allKeys].firstObject;
        
        id obj = [dict valueForKey:key];
        UMComMutiTextRunClickUser *userRun = [[UMComMutiTextRunClickUser alloc]init];
        userRun.text = @"这是一个用户";
        userRun.textColor = [UIColor yellowColor];//[UMComTools colorWithHexString:FontColorBlue];
        userRun.range = NSRangeFromString(key);
        userRun.font = [UIFont systemFontOfSize:12];//UMComFontNotoSansLightWithSafeSize(13);
        [userRun decorateToAttributedString:attributedString range:userRun.range];
        [runsArr addObject:userRun];
        
        UMComMutiTextRunComment *run = [[UMComMutiTextRunComment alloc]init];
        run.text =@"这是一条评论";
        run.textColor = [UIColor blackColor];
        run.range = NSRangeFromString(key);
        run.font = [UIFont systemFontOfSize:31];//UMComFontNotoSansLightWithSafeSize(13);
        [run decorateToAttributedString:attributedString range:run.range];
        [runsArr addObject:run];
    }
    return runsArr;
}

@end



@implementation UMComMutiTextRunTopic

/**
 *  向字符串中添加相关Run类型属性
 */
- (void)decorateToAttributedString:(NSMutableAttributedString *)attributedString range:(NSRange)range
{
    if (attributedString.length == 0) {
        return;
    }
    [super decorateToAttributedString:attributedString range:range];
    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:self.textColor range:range];
}

/**
 *  解析字符串中名字和话题内容生成Run对象
 *
 *  @param attributedString 内容
 *
 *  @return UMComMutiTextRunURL对象数组
 */
+ (NSArray *)runsForAttributedString:(NSMutableAttributedString *)attributedString
{
    NSString *string = attributedString.string;
    NSMutableArray *array = [NSMutableArray array];
    
    NSError *error = nil;
    
    NSString *regulaStr = @"(#([\\u4e00-\\u9fa5_a-zA-Z0-9]+)#)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error == nil)
    {
        NSArray *arrayOfAllMatches = [regex matchesInString:string
                                                    options:0
                                                      range:NSMakeRange(0, [string length])];
        for (NSTextCheckingResult *match in arrayOfAllMatches)
        {
            NSString* substringForMatch = [string substringWithRange:match.range];
            
            UMComMutiTextRunTopic *run = [[UMComMutiTextRunTopic alloc] init];
            run.range    = match.range;
            run.text     = substringForMatch;
            run.drawSelf = NO;
            run.textColor = [UIColor redColor];
            run.font = [UIFont systemFontOfSize:16];
            [run decorateToAttributedString:attributedString range:match.range];
            [array addObject:run ];
        }
    }
    
    NSString *userNameRegulaStr = @"(@[\\u4e00-\\u9fa5_a-zA-Z0-9]+)";
    NSRegularExpression *userNameRegex = [NSRegularExpression regularExpressionWithPattern:userNameRegulaStr
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:&error];
    if (error == nil)
    {
        NSArray *arrayOfAllMatches = [userNameRegex matchesInString:string
                                                            options:0
                                                              range:NSMakeRange(0, [string length])];
        for (NSTextCheckingResult *match in arrayOfAllMatches)
        {
            NSString* substringForMatch = [string substringWithRange:match.range];
            UMComMutiTextRunClickUser *run = [[UMComMutiTextRunClickUser alloc] init];
            run.range    = match.range;
            run.text     = substringForMatch;
            run.drawSelf = NO;
            run.textColor = [UIColor grayColor];
            [run decorateToAttributedString:attributedString range:match.range];
            [array addObject:run ];
        }
    }
    return array;
}


@end






@implementation UMComMutiTextRunURL

/**
 *  向字符串中添加相关Run类型属性
 */
- (void)decorateToAttributedString:(NSMutableAttributedString *)attributedString range:(NSRange)range
{
    if (attributedString.length == 0) {
        return;
    }
    [super decorateToAttributedString:attributedString range:range];
    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor blueColor].CGColor range:range];
}

/**
 *  解析字符串中url内容生成Run对象
 *
 *  @param attributedString 内容
 *
 *  @return UMComMutiTextRunURL对象数组
 */
+ (NSArray *)runsForAttributedString:(NSMutableAttributedString *)attributedString
{
    NSString *string = attributedString.string;
    NSMutableArray *array = [NSMutableArray array];
    
    NSError *error = nil;;
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error == nil)
    {
        NSArray *arrayOfAllMatches = [regex matchesInString:string
                                                    options:0
                                                      range:NSMakeRange(0, [string length])];
        
        for (NSTextCheckingResult *match in arrayOfAllMatches)
        {
            NSString* substringForMatch = [string substringWithRange:match.range];
            
            UMComMutiTextRunURL *run = [[UMComMutiTextRunURL alloc] init];
            run.range    = match.range;
            run.text     = substringForMatch;
            run.drawSelf = NO;
            [run decorateToAttributedString:attributedString range:match.range];
            [array addObject:run ];
        }
    }
    
    return array;
}


@end




@implementation UMComMutiTextRunEmoji

/**
 *  返回表情数组
 */
+ (NSArray *) emojiStringArray
{
    return [NSArray arrayWithObjects:@"[smile]",@"[cry]",@"[hei]",nil];
}

/**
 *  解析字符串中url内容生成Run对象
 *
 *  @param attributedString 内容
 *
 *  @return UMComMutiTextRunURL对象数组
 */
+ (NSArray *)runsForAttributedString:(NSMutableAttributedString *)attributedString
{
    NSString *markL       = @"[";
    NSString *markR       = @"]";
    NSString *string      = attributedString.string;
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *stack = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < string.length; i++)
    {
        NSString *s = [string substringWithRange:NSMakeRange(i, 1)];
        
        if (([s isEqualToString:markL]) || ((stack.count > 0) && [stack[0] isEqualToString:markL]))
        {
            if (([s isEqualToString:markL]) && ((stack.count > 0) && [stack[0] isEqualToString:markL]))
            {
                [stack removeAllObjects];
            }
            
            [stack addObject:s];
            
            if ([s isEqualToString:markR] || (i == string.length - 1))
            {
                NSMutableString *emojiStr = [[NSMutableString alloc] init];
                for (NSString *c in stack)
                {
                    [emojiStr appendString:c];
                }
                
                if ([[UMComMutiTextRunEmoji emojiStringArray] containsObject:emojiStr])
                {
                    NSRange range = NSMakeRange(i + 1 - emojiStr.length, emojiStr.length);
                    
                    [attributedString replaceCharactersInRange:range withString:@" "];
                    
                    UMComMutiTextRunEmoji *run = [[UMComMutiTextRunEmoji alloc] init];
                    run.range    = NSMakeRange(i + 1 - emojiStr.length, 1);
                    run.text     = emojiStr;
                    run.drawSelf = YES;
                    [run decorateToAttributedString:attributedString range:run.range];
                    
                    [array addObject:run];
                }
                
                [stack removeAllObjects];
            }
        }
    }
    
    return array;
}

/**
 *  绘制Run内容
 */
- (void)drawRunWithRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSString *emojiString = [NSString stringWithFormat:@"%@.png",self.text];
    
    UIImage *image = [UIImage imageNamed:emojiString];
    if (image)
    {
        CGContextDrawImage(context, rect, image.CGImage);
    }
}

@end
