//
//  UMComMutiStyleTextView.m
//  UMCommunity
//
//  Created by umeng on 15-3-5.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import "UMComMutiStyleTextView.h"
//#import "UMComSyntaxHighlightTextStorage.h"
//#import "UMComComment.h"
#import <CoreText/CoreText.h>


@interface UMComMutiStyleTextView ()

@property (nonatomic,strong) NSMutableArray *runs;
@property (nonatomic,strong) NSMutableDictionary *runRectDictionary;
@property (nonatomic,strong) UMComMutiTextRun *touchRun;


@end

@implementation UMComMutiStyleTextView
{
    CTFrameRef frameRef;
    
}

- (id)init
{
    self = [super init];
    if (self) {
        [self createDefault];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createDefault];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapInCerrentView:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}


#pragma mark - CreateDefault

- (void)createDefault
{
    self.textLayer = [CALayer layer];
    UIImage *image = [UIImage imageNamed:@"origin_image_bg"];
    self.textLayer.contents = (id) image.CGImage;
    //public
    self.originString = @"";
    self.font        = [UIFont systemFontOfSize:13.0f];
    self.textColor   = [UIColor clearColor];
    self.runType = UMComMutiTextRunNoneType;
    self.lineSpace   = 2.0f;
    self.heightOffset = 0.0f;
    self.attributedString = nil;
    
    //private
    self.runs        = [NSMutableArray array];
    self.runRectDictionary = [NSMutableDictionary dictionary];
    self.touchRun = nil;
   
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.frame];
    self.backGroundImageView = bgImageView;
}


- (void)awakeFromNib
{
    [self createDefault];
}

#pragma mark - Set
- (void)setOriginString:(NSString *)originString
{
    [self setNeedsDisplay];
    _originString = originString;
}

- (void)setText:(NSString *)text
{
}

- (void)setLineSpace:(CGFloat)lineSpace
{
    //    [self setNeedsDisplay];
    _lineSpace = lineSpace;
    
}


//
//#pragma mark - Draw Rect
//
//- (void)drawRect:(CGRect)rect
//{
//    if (self.originString == nil || self.originString.length == 0){
//        return;
//    }
//    [self.runs removeAllObjects];
//    [self.runRectDictionary removeAllObjects];
//    
//    CGRect viewRect = CGRectMake(0, -self.heightOffset/2, rect.size.width, rect.size.height);//
//    //绘制的文本
//    NSMutableAttributedString *attString = nil;
//    
//    if (self.attributedString == nil)
//    {
//        attString = [[self class] createAttributedStringWithText:self.originString font:self.font lineSpace:self.lineSpace];
//    }
//    else
//    {
//        attString = self.attributedString;
//    }
//    NSArray *runs = [[self class] createTextRunsWithAttString:attString runTypeList:UMComMutiTextRunAllType];
//        [self.runs addObjectsFromArray:runs];
//    
//    
//    //绘图上下文
//    CGContextRef contextRef = UIGraphicsGetCurrentContext();
//   
//    //修正坐标系
//    CGAffineTransform affineTransform = CGAffineTransformIdentity;
//    affineTransform = CGAffineTransformMakeTranslation(0.0, viewRect.size.height);
//    affineTransform = CGAffineTransformScale(affineTransform, 1.0, -1.0);
//    CGContextConcatCTM(contextRef, affineTransform);
//    
//    //创建一个用来描画文字的路径，其区域为viewRect  CGPath
//    CGMutablePathRef pathRef = CGPathCreateMutable();
//    CGPathAddRect(pathRef, NULL, viewRect);
//    
//    //创建一个framesetter用来管理描画文字的frame  CTFramesetter
//    CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attString);
//    
//    //创建由framesetter管理的frame，是描画文字的一个视图范围  CTFrame
////    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetterRef, CFRangeMake(0, 0), pathRef, nil);
//    
//    //创建由framesetter管理的frame，是描画文字的一个视图范围  CTFrame
//   frameRef = CTFramesetterCreateFrame(framesetterRef, CFRangeMake(0, 0), pathRef, nil);
//    
//
//    //通过context在frame中描画文字内容
//    CTFrameDraw(frameRef, contextRef);
//    [self setRunsKeysToRunRect];
//
//    CFRelease(pathRef);
////    CFRelease(frameRef);
//    CFRelease(framesetterRef);
//}
//
//- (void)setRunsKeysToRunRect
//{
//    CFArrayRef lines = CTFrameGetLines(frameRef);
//    CGPoint lineOrigins[CFArrayGetCount(lines)];
//    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), lineOrigins);
//    
//    
//    for (int i = 0; i < CFArrayGetCount(lines); i++)
//    {
//        CTLineRef lineRef= CFArrayGetValueAtIndex(lines, i);
//        CGFloat lineAscent;
//        CGFloat lineDescent;
//        CGFloat lineLeading;
//        CGPoint lineOrigin = CGPointMake(lineOrigins[i].x, lineOrigins[i].y);//
//        CTLineGetTypographicBounds(lineRef, &lineAscent, &lineDescent, &lineLeading);
//        CFArrayRef runs = CTLineGetGlyphRuns(lineRef);
//        
//        for (int j = 0; j < CFArrayGetCount(runs); j++)
//        {
//            CTRunRef runRef = CFArrayGetValueAtIndex(runs, j);
//            CGFloat runAscent;
//            CGFloat runDescent;
//            CGRect runRect;
//            
//            runRect.size.width = CTRunGetTypographicBounds(runRef, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
//            runRect = CGRectMake(lineOrigin.x + CTLineGetOffsetForStringIndex(lineRef, CTRunGetStringRange(runRef).location, NULL),
//                                 lineOrigin.y,
//                                 runRect.size.width,
//                                 runAscent + runDescent);
//            
//            NSDictionary * attributes = (__bridge NSDictionary *)CTRunGetAttributes(runRef);
//            UMComMutiTextRun *mutiTextRun = [attributes objectForKey:UMComMutiTextRunAttributedName];
//            if (mutiTextRun.drawSelf)
//            {
//                CGFloat runAscent,runDescent;
//                CGFloat runWidth  = CTRunGetTypographicBounds(runRef, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
//                CGFloat runHeight = (lineAscent + lineDescent );
//                CGFloat runPointX = runRect.origin.x + lineOrigin.x;
//                CGFloat runPointY = lineOrigin.y;
//                
//                CGRect runRectDraw = CGRectMake(runPointX, runPointY, runWidth, runHeight);
//                
//                [mutiTextRun drawRunWithRect:runRectDraw];
//                
//                [self.runRectDictionary setObject:mutiTextRun forKey:[NSValue valueWithCGRect:runRectDraw]];
//            }
//            else
//            {
//                if (mutiTextRun)
//                {
//                    [self.runRectDictionary setObject:mutiTextRun forKey:[NSValue valueWithCGRect:runRect]];
//                }
//            }
//        }
//    }
//}


- (void)tapInCerrentView:(UITapGestureRecognizer *)tap
{
    CGPoint location = [tap locationInView:self];
//    [self touchInLocation:location];
    CGPoint runLocation = CGPointMake(location.x, self.frame.size.height - location.y+self.heightOffset/2+2);
    
    __weak UMComMutiStyleTextView *weakSelf = self;
    
    if (self.clickOnlinkText) {
        [self.runRectDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop){
            CGRect rect = [((NSValue *)key) CGRectValue];
            if(CGRectContainsPoint(rect, runLocation))
            {
                weakSelf.touchRun = object;
                weakSelf.clickOnlinkText(object);
            }
        }];
    }

}


//CFIndex CFIndexGet(CGPoint point,CTFrameRef frame){
//
//    //获取每一行
//    CFArrayRef lines = CTFrameGetLines(frame);
//    CGPoint origins[CFArrayGetCount(lines)];
//    //获取每行的原点坐标
//    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
//    CTLineRef line = NULL;
//    CGPoint lineOrigin = CGPointZero;
//    CGPathRef path = CTFrameGetPath(frame);
//    //获取整个CTFrame的大小
//    CGRect rect = CGPathGetBoundingBox(path);
//    for (int i= 0; i < CFArrayGetCount(lines); i++)
//    {
//        CGPoint origin = origins[i];
//        //坐标转换，把每行的原点坐标转换为uiview的坐标体系
//        CGFloat y = rect.origin.y + rect.size.height - origin.y;
//        //判断点击的位置处于那一行范围内
//        if ((point.y <= y) && (point.x >= origin.x))
//        {
//            line = CFArrayGetValueAtIndex(lines, i);
//            lineOrigin = origin;
//            break;
//        }
//    }
//    point.x -= lineOrigin.x;
//    //获取点击位置所处的字符位置，就是相当于点击了第几个字符
//    CFIndex index = CTLineGetStringIndexForPosition(line, point);
//    return index;
//}


////接受触摸事件
//-(void)touchInLocation:(CGPoint)location{
////    //获取UITouch对象
////    UITouch *touch = [touches anyObject];
////    //获取触摸点击当前view的坐标位置
////    CGPoint location = [touch locationInView:self];
//    NSLog(@"touch:%@",NSStringFromCGPoint(location));
//    //获取每一行
//    CFArrayRef lines = CTFrameGetLines(frameRef);
//    CGPoint origins[CFArrayGetCount(lines)];
//    //获取每行的原点坐标
//    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins);
//    CTLineRef line = NULL;
//    CGPoint lineOrigin = CGPointZero;
//    for (int i= 0; i < CFArrayGetCount(lines); i++)
//    {
//        CGPoint origin = origins[i];
//        CGPathRef path = CTFrameGetPath(frameRef);
//        //获取整个CTFrame的大小
//        CGRect rect = CGPathGetBoundingBox(path);
////        NSLog(@"origin:%@",NSStringFromCGPoint(origin));
////        NSLog(@"rect:%@",NSStringFromCGRect(rect));
//        //坐标转换，把每行的原点坐标转换为uiview的坐标体系
//        CGFloat y = rect.size.height - origin.y;// rect.origin.y +
//
////        CGPoint runLocation = CGPointMake(location.x, self.frame.size.height - location.y+self.heightOffset/2+2);
//
//        NSLog(@"y:%f",y);
//        //判断点击的位置处于那一行范围内
//        if ((location.y <= y) && (location.x >= origin.x))
//        {
//            line = CFArrayGetValueAtIndex(lines, i);
//            lineOrigin = origin;
//            break;
//        }
//    }
//
//    location.x -= lineOrigin.x;
//    //获取点击位置所处的字符位置，就是相当于点击了第几个字符
//    CFIndex index = CTLineGetStringIndexForPosition(line, location);
//    NSLog(@"index:%ld",index);
//    //判断点击的字符是否在需要处理点击事件的字符串范围内，这里是hard code了需要触发事件的字符串范围
//    if (index>=0&&index<=10) {
////        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"click event" message:[_originString substringWithRange:NSMakeRange(0, 10)] delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
////        [alert show];
//    }
//
//}

- (void)clickOnLinkText:(id)object inRange:(NSRange)range
{
    
    if (_clickOnlinkText) {
        _clickOnlinkText(object);
    }
}

//#pragma mark - Touches
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];
//    
//    CGPoint location =[(UITouch *)[touches anyObject] locationInView:self];
//    CGPoint runLocation = CGPointMake(location.x, self.frame.size.height - location.y);
//    
//    __weak UMComMutiStyleTextView *weakSelf = self;
//    
//    
//    if (self.clickOnlinkText) {
//        [self.runRectDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop){
//            CGRect rect = [((NSValue *)key) CGRectValue];
//            if(CGRectContainsPoint(rect, runLocation))
//            {
//                weakSelf.touchRun = object;
//                self.clickOnlinkText(object);
//                
//            }
//        }];
//    }
//    
//    
//    if (self.delegage && [self.delegage respondsToSelector:@selector(mutiTextView: touchBeginRun:)])
//    {
//        __weak UMComMutiStyleTextView *weakSelf = self;
//        
//        [self.runRectDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop){
//            
//            CGRect rect = [((NSValue *)key) CGRectValue];
//            if(CGRectContainsPoint(rect, runLocation))
//            {
//                self.touchRun = object;
//                [weakSelf.delegage mutiTextView:weakSelf touchBeginRun:object];
//         
//            }
//        }];
//    }
//    
//
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesMoved:touches withEvent:event];
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesEnded:touches withEvent:event];
//    
//    CGPoint location = [(UITouch *)[touches anyObject] locationInView:self];
//    CGPoint runLocation = CGPointMake(location.x, self.frame.size.height - location.y);
//    
//    if (self.delegage && [self.delegage respondsToSelector:@selector(mutiTextView: touchBeginRun:)])
//    {
//        __weak UMComMutiStyleTextView *weakSelf = self;
//        
//        [self.runRectDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
//            
//            CGRect rect = [((NSValue *)key) CGRectValue];
//            if(CGRectContainsPoint(rect, runLocation))
//            {
//                self.touchRun = obj;
//                [weakSelf.delegage mutiTextView:weakSelf touchEndRun:obj];
//            }
//        }];
//    }
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesCancelled:touches withEvent:event];
//    
//    CGPoint location = [(UITouch *)[touches anyObject] locationInView:self];
//    CGPoint runLocation = CGPointMake(location.x, self.frame.size.height - location.y);
//    
//    if (self.delegage && [self.delegage respondsToSelector:@selector(mutiTextView: touchBeginRun:)])
//    {
//        __weak UMComMutiStyleTextView *weakSelf = self;
//        
//        [self.runRectDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
//            
//            CGRect rect = [((NSValue *)key) CGRectValue];
//            if(CGRectContainsPoint(rect, runLocation))
//            {
//                self.touchRun = obj;
//                [weakSelf.delegage mutiTextView:weakSelf touchCanceledRun:obj];
//            }
//        }];
//    }
//}
//
//- (UIResponder*)nextResponder
//{
//    [super nextResponder];
//    
//    return self.touchRun;
//}



#pragma mark -

+ (NSMutableAttributedString *)createAttributedStringWithText:(NSString *)text font:(UIFont *)font lineSpace:(CGFloat)lineSpace
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    //设置字体
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    [attString addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0,attString.length)];
    CFRelease(fontRef);
    
    //添加换行模式
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByCharWrapping;
    lineBreakMode.spec        = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value       = &lineBreak;
    lineBreakMode.valueSize   = sizeof(lineBreak);

    //行距
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacing;
    lineSpaceStyle.valueSize = sizeof(lineSpace);
    lineSpaceStyle.value =&lineSpace;
    
//    //创建文本对齐方式
//    CTTextAlignment alignment = 0;//左对齐
//    CTParagraphStyleSetting alignmentStyle;
//    alignmentStyle.spec=kCTParagraphStyleSpecifierAlignment;//指定为对齐属性
//    alignmentStyle.valueSize=sizeof(alignment);
//    alignmentStyle.value=&alignment;
    
    
//    CGFloat LineSpacingAdjustment = 10;//
//    CTParagraphStyleSetting LineSpacingAdjustmentStyle;
//    LineSpacingAdjustmentStyle.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;//
//    LineSpacingAdjustmentStyle.valueSize=sizeof(LineSpacingAdjustment);
//    LineSpacingAdjustmentStyle.value=&LineSpacingAdjustment;
    
    
    CTParagraphStyleSetting settings[] = {lineSpaceStyle,lineBreakMode};
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, sizeof(settings)/sizeof(settings[0]));
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(__bridge id)style forKey:(id)kCTParagraphStyleAttributeName ];
    CFRelease(style);
    
    [attString addAttributes:attributes range:NSMakeRange(0, [attString length])];
    
    return attString;
}



+ (NSArray *)createTextRunsWithAttString:(NSMutableAttributedString *)attString runType:(UMComMutiTextRunTypeList)type clickDicts:(NSMutableArray *)dicts
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (UMComMutiTextRunLikeType == type)
    {
        [array addObjectsFromArray:[UMComMutiTextRunLike runsForAttributedString:attString withClickDicts:dicts]];
    }
    if (UMComMutiTextRunCommentType == type)
    {
        [array addObjectsFromArray:[UMComMutiTextRunComment runsForAttributedString:attString withClickDicts:dicts]];
    }
    if (UMComMutiTextRunFeedContentType == type)
    {
        [array addObjectsFromArray:[UMComMutiTextRunTopic runsForAttributedString:attString]];
    }
    return  array;
}

+ (NSArray *)createTextRunsWithAttString:(NSMutableAttributedString *)attString runTypeList:(UMComMutiTextRunTypeList)typeList
{

    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (UMComMutiTextRunLikeType == typeList)
    {
        [array addObjectsFromArray:[UMComMutiTextRunLike runsForAttributedString:attString withClickDicts:nil]];
    }
    if (UMComMutiTextRunCommentType == typeList)
    {
        [array addObjectsFromArray:[UMComMutiTextRunComment runsForAttributedString:attString withClickDicts:nil]];
    }
    if (UMComMutiTextRunFeedContentType == typeList)
    {
        [array addObjectsFromArray:[UMComMutiTextRunTopic runsForAttributedString:attString]];
    }
    if (UMComMutiTextRunCommonType == typeList) {
        [array addObjectsFromArray:[UMComMutiTextRunCommomText runsForAttributedString:attString]];
    }
    if (UMComMutiTextRunURLType == typeList) {
        [array addObjectsFromArray:[UMComMutiTextRunURL runsForAttributedString:attString]];
    }
    if (UMComMutiTextRunEmojiType == typeList) {
        [array addObjectsFromArray:[UMComMutiTextRunEmoji runsForAttributedString:attString]];
    }
    if (UMComMutiTextRunAllType == typeList) {
//        [array addObjectsFromArray:[UMComMutiTextRunLike runsForAttributedString:attString withClickDicts:nil]];
//        [array addObjectsFromArray:[UMComMutiTextRunComment runsForAttributedString:attString withClickDicts:nil]];
//        [array addObjectsFromArray:[UMComMutiTextRunTopic runsForAttributedString:attString]];
//        [array addObjectsFromArray:[UMComMutiTextRunCommomText runsForAttributedString:attString]];
        [array addObjectsFromArray:[UMComMutiTextRunURL runsForAttributedString:attString]];
        [array addObjectsFromArray:[UMComMutiTextRunEmoji runsForAttributedString:attString]];
    }
    return  array;


}


+ (CGRect)boundingRectWithSize:(CGSize)size font:(UIFont *)font AttString:(NSMutableAttributedString *)attString
{

    if (attString.length == 0) {
        return CGRectMake(0, 0, size.width, 0);
    }
    NSDictionary *dic = [attString attributesAtIndex:0 effectiveRange:nil];
    CTParagraphStyleRef paragraphStyle = (__bridge CTParagraphStyleRef)[dic objectForKey:(id)kCTParagraphStyleAttributeName];
    CGFloat linespace = 0;
    
    CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierLineSpacing, sizeof(linespace), &linespace);
    
    CGFloat height = 0;
    CGFloat width = 0;
    CFIndex lineIndex = 0;
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathAddRect(pathRef, NULL, CGRectMake(0, 0, size.width, size.height));
    CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attString);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetterRef, CFRangeMake(0, 0), pathRef, nil);
    CFArrayRef lines = CTFrameGetLines(frameRef);
    
    lineIndex = CFArrayGetCount(lines);
    
    if (lineIndex > 1)
    {
        for (int i = 0; i <lineIndex ; i++)
        {
            CTLineRef lineRef= CFArrayGetValueAtIndex(lines, i);
            CGFloat lineAscent;
            CGFloat lineDescent;
            CGFloat lineLeading;
            CTLineGetTypographicBounds(lineRef, &lineAscent, &lineDescent, &lineLeading);
            
            if (i == lineIndex - 1)
            {
                height += (lineAscent + lineDescent +linespace);
            }
            else
            {
                height += (lineAscent + lineDescent + linespace);
            }
        }
        
        width = size.width;
    }
    else
    {
        for (int i = 0; i <lineIndex ; i++)
        {
            CTLineRef lineRef= CFArrayGetValueAtIndex(lines, i);
            CGRect rect = CTLineGetBoundsWithOptions(lineRef,kCTLineBoundsExcludeTypographicShifts);
            width = rect.size.width;
            
            CGFloat lineAscent;
            CGFloat lineDescent;
            CGFloat lineLeading;
            CTLineGetTypographicBounds(lineRef, &lineAscent, &lineDescent, &lineLeading);
            
            height += (lineAscent + lineDescent + lineLeading + linespace);
        }
        
        height = height;
    }
    
    CFRelease(pathRef);
    CFRelease(frameRef);
    CFRelease(framesetterRef);
    CGRect rect = CGRectMake(0,0,width,height);
    
    return rect;
}

+ (CGRect)boundingRectWithSize:(CGSize)size font:(UIFont *)font string:(NSString *)string lineSpace:(CGFloat )lineSpace
{
    NSMutableAttributedString *attributedString = [[self class] createAttributedStringWithText:string font:font lineSpace:lineSpace];
    return [[self class] boundingRectWithSize:size font:font AttString:attributedString];
}


@end

